set :application, "date"
  set :user, "app"
  set :use_sudo, false

  set :repository,  "git@github.com:mathgraph/date_night_out.git"
  set :deploy_to, "/var/www/#{application}"
  set :scm, :git
  set :git_enable_submodules, 1         # Make sure git submodules are populated

  set :port, 22                      # The port you've setup in the SSH setup section
  set :location, "192.168.1.150"
  role :app, location
  role :web, location
  role :db,  location, :primary => true
  
  set :rails_env,      "production"

  namespace :deploy do
    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
    end

    desc "Make symlink for database.yml" 
    task :symlink_dbyaml do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
    end
    
    desc "Make symlink for smtp_gmail.yml"
    task :symlink_smtp_gmail do
      run "ln -nfs #{shared_path}/config/smtp_gmail.yml #{release_path}/config/smtp_gmail.yml"
    end

    desc "Create empty database.yml in shared path" 
    task :create_dbyaml do
      run "mkdir -p #{shared_path}/config" 
      put '', "#{shared_path}/config/database.yml" 
    end
  end
  
  namespace :delayed_job do
    rails_env = "production"
    desc "Stop the delayed_job process"
    task :stop, :roles => :app do
      run "cd #{current_path};"
      run "#{sudo} /etc/init.d/delayed_job stop -e #{rails_env}"
    end
  
    desc "Start the delayed_job process"
    task :start, :roles => :app do
      run "cd #{current_path};"
      run "#{sudo} /etc/init.d/delayed_job start -e #{rails_env}"
    end
  
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do
      run "cd #{current_path};"
      run "#{sudo} /etc/init.d/delayed_job restart -e #{rails_env}"
    end
  end

  after 'deploy:setup', 'deploy:create_dbyaml'
  after 'deploy:update_code', 'deploy:symlink_dbyaml'
  after 'deploy:update_code', 'deploy:symlink_smtp_gmail'
  
  after "deploy:stop",    "delayed_job:stop"
  after "deploy:start",   "delayed_job:start"
  after "deploy:restart", "delayed_job:restart"
  
  after 'deploy:update_code', 'deploy:migrate'
  
  after "deploy", "deploy:cleanup"
