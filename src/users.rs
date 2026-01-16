use anyhow::{Context, Result};

use inquire::Select;
use serde::Deserialize;
use std::collections::HashMap;
use std::fmt;

#[derive(Debug, Deserialize)]
struct LoginUsers {
    #[serde(flatten)]
    users: HashMap<String, UserEntry>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct UserEntry {
    #[serde(rename = "AccountName")]
    pub account_name: String,
    #[serde(rename = "PersonaName")]
    pub persona_name: String,
    #[serde(skip)]
    pub steam_id: String,
}

impl fmt::Display for UserEntry {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{} ({})", self.persona_name, self.account_name)
    }
}

pub fn get_local_users(steam_path: &std::path::Path) -> Result<Vec<UserEntry>> {
    let config_path = steam_path.join("config").join("loginusers.vdf");

    if !config_path.exists() {
        anyhow::bail!("Could not find loginusers.vdf at {}", config_path.display());
    }
    let content = std::fs::read_to_string(&config_path).context("Failed to read loginusers.vdf")?;

    let parsed: LoginUsers =
        keyvalues_serde::from_str(&content).context("Failed to parse loginusers.vdf")?;

    let users: Vec<UserEntry> = parsed
        .users
        .into_iter()
        .map(|(id, mut user)| {
            user.steam_id = id;
            user
        })
        .collect();

    Ok(users)
}

pub fn select_user(users: Vec<UserEntry>) -> Result<UserEntry> {
    if users.is_empty() {
        anyhow::bail!("No users found in loginusers.vdf");
    }

    if users.len() == 1 {
        println!("Only one user found: {}", users[0]);
        return Ok(users[0].clone());
    }

    let selection = Select::new("Select the current user:", users)
        .prompt()
        .context("Failed to select user")?;

    Ok(selection)
}
