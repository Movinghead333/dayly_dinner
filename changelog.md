# Changelog:

## Commit 3:
- Added a dark theme as default theme to the app.
- Minor development on UI of `RecipeListScreen`
- Loading time on middle class phones seems to be quite slow (some seconds on cold-start)
- Lower version back to 1.0.0+1 so when updating the app the db-data is not lost

## Commit 2: (version 1.0.1+2)
- Added Confirmation dialog for preparing a recipe
- Made `ConfirmationDialog` its own widget for reuseability and readability
- Swapped order of buttons in `RecipeCreationDialog` to stay consistent (cancel button should always be the most right button)

## Commit 1: (version 1.0.0+1)
- Initial commit