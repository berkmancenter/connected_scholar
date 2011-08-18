require "uri"
require "open3"

# This class represents a resource that resides in a git repository - much like Bundler's :git resources.
# It can be used to checkout a particular version of a git repo and install it somewhere.  This is useful for resources
# that a not Gems.  If the repo is a gem or has a .gemspec in it, then its probably better to use Bundler.
class GitResource
  attr_reader :uri, :install_path

  def initialize(uri, install_path, revision)
    @uri = uri
    @install_path = install_path
    @revision = revision
    @submodules = false
  end

  def path
    @install_path
  end

  def cache_path
    @cache_path ||= URI.parse(@uri)
  end

  # This method tests if the given repo is at the specificed revision.  However, it will not test for staged changes.
  # @param [String] the git rev to test for.  defaults the revision defined for this instance
  # @return [true, false] true if the give rev is checked out, false if not.
  def ref_checked_out?(ref=@revision)
    Dir.chdir(path) do
      cur_ref = git "rev-parse HEAD"
      return cur_ref.strip == ref
    end
    false
  end

  # This method checks out a the git rev specified when constructing this instance.  Really, it just does a 'git reset --hard'
  def checkout
    unless File.exist?(File.join(path, ".git"))
      FileUtils.mkdir_p(path)
      FileUtils.rm_rf(path)
      git %|clone --no-checkout "#{cache_path}" "#{path}"|
      File.chmod((0777 & ~File.umask), path)
    end
    Dir.chdir(path) do
      git %|fetch --force --quiet --tags "#{cache_path}"|
      git "reset --hard #{@revision}"

      if @submodules
        git "submodule init"
        git "submodule update"
      end
    end
  end

  private

  def allow_git_ops?
    true
  end

  def git(command)
    if allow_git_ops?
      out = %x{git #{command}}

      if $?.exitstatus != 0
        msg = "GitResource error: command `git #{command}` in directory #{Dir.pwd} has failed."
        raise GitError, msg
      end
      out
    else
      raise GitError, "Trying to run a `git #{command}` at runtime.\n\nCALLER: #{caller.join("\n")}"
    end
  end

  class GitError < Exception

  end
end