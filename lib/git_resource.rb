require "uri"
require "open3"

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