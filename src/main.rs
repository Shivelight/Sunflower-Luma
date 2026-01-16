mod users;

use anyhow::{Context, Result};
use steamlocate::SteamDir;

fn main() -> Result<()> {
    let steam_dir = SteamDir::locate().context("Could not locate Steam installation")?;
    println!("Found Steam at: {}", steam_dir.path().display());

    let users = users::get_local_users(steam_dir.path()).context("Failed to get local users")?;
    let current_user = users::select_user(users).context("Failed to select user")?;

    println!(
        "Selected user: {} ({})",
        current_user.persona_name, current_user.steam_id
    );
    println!("Scanning for installed apps not owned by this user...\n");

    let libraries = steam_dir.libraries().context("Failed to get libraries")?;

    let mut shared_appids: Vec<u64> = Vec::new();

    for library in libraries {
        let library = match library {
            Ok(l) => l,
            Err(e) => {
                eprintln!("Warning: could not read library: {}", e);
                continue;
            }
        };

        for app in library.apps() {
            let app = match app {
                Ok(a) => a,
                Err(e) => {
                    eprintln!("Warning: could not read app: {}", e);
                    continue;
                }
            };

            let last_user = app.last_user.unwrap_or(0);
            let current_user_id: u64 = current_user.steam_id.parse().unwrap_or(0);

            // If the last_user does NOT match the current user, it's likely a family shared game
            // (or a game installed by another user on the same PC).
            // TODO: find out how Steam store local Steam Family collections,
            //       I'm hopeful this won't be a problem though
            if last_user != current_user_id && last_user != 0 {
                let appname = app.name.as_deref().unwrap_or("Unknown");
                println!(
                    "Found family shared app: {appname} (AppID: {}) - Owner ID: {}",
                    app.app_id, last_user
                );
                shared_appids.push(app.app_id as u64);
                for (_, depot) in app.installed_depots {
                    if let Some(dlc_appid) = depot.dlc_app_id {
                        // TODO: get dlc name from API, a lot easier than messing around with steam local files
                        //       DO NOT FORGET TO CACHE IT SOMEWJERE
                        println!("- Found DLC: Unknown App (AppID: {dlc_appid})");
                        shared_appids.push(dlc_appid);
                    }
                }
            }
        }
    }

    if shared_appids.is_empty() {
        println!("No family shared apps found.");
    } else {
        let app_list_dir = steam_dir.path().join("AppList");
        if app_list_dir.exists() {
            std::fs::remove_dir_all(&app_list_dir)
                .context("Failed to remove existing AppList directory")?;
        }

        std::fs::create_dir_all(&app_list_dir).context("Failed to create AppList directory")?;

        for (i, app_id) in shared_appids.iter().enumerate() {
            let file_path = app_list_dir.join(format!("{}.txt", i));
            std::fs::write(&file_path, app_id.to_string())
                .context(format!("Failed to write to {}", file_path.display()))?;
        }

        println!(
            "Wrote {} shared app IDs to {}",
            shared_appids.len(),
            app_list_dir.display()
        );
    }

    let _ = inquire::Text::new("Press Enter to exit...").prompt();
    Ok(())
}
