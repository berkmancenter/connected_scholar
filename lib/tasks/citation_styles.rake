namespace :citation_styles do
  task :checkout => :environment do
    cs_yaml = YAML.load_file('config/citation_styles.yml')
    
    vendor_path = File.join(Rails.root, 'public', 'vendor')
    install_path = File.join(vendor_path, cs_yaml['dir'])
    
    url = cs_yaml['url']
    ref = cs_yaml['ref']
    
    system "mkdir #{vendor_path}" unless Dir.exists?(vendor_path)
    system "mkdir #{install_path}" unless Dir.exists?(install_path)

    git = GitResource.new(url, install_path, ref)
    git.checkout
  end
end