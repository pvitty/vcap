class PlayPlugin < StagingPlugin
  # TODO - Is there a way to avoid this without some kind of 'register' callback?
  # e.g. StagingPlugin.register('sinatra', __FILE__)
  def framework
    'play'
  end

  def stage_application
    Dir.chdir(destination_directory) do
      create_app_directories
      copy_source_files
      create_startup_script
    end
  end

  def start_command
    # start play
    "/opt/play-1.2/play start"
  end

  # Nicer kill script that attempts an INT first, and then only if the process doesn't die will
  # we try a -9.
  def stop_script_template
    <<-SCRIPT
    #!/bin/bash
    MAX_NICE_KILL_ATTEMPTS=20
    attempts=0
    kill -INT $STARTED
    while pgrep $STARTED >/dev/null; do
      (( ++attempts >= MAX_NICE_KILL_ATTEMPTS )) && break
      sleep 1
    done
    pgrep $STARTED && kill -9 $STARTED
    kill -9 $PPID
    SCRIPT
  end

  private
  def startup_script
    vars = environment_hash
    generate_startup_script(vars)
  end

  
  end
end

