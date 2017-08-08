. .\SqlVariables.ps1

### Structure
#  functions
        # Find-MbStudio (lookup of CID for existance, db short, db path
        # Run-SqlSource (executes SQL statement, paramters are statement, dbShort, dbPath)
#  sql statements as variables
        # Create backups (works for either)
        # Create Source tables
        # Check for demographics (encrypted/decrypted items)
        # Check en/de success
        # Update clientIds to avoid overlap
#  gui
        # Split into tabs
        # Tab one: gather source & target CIDs, validate
        # Tab two: LOW PRIORITY
                # Allow user to choose what criteria, and what data types, to bring
        # Tab three: create source table (or datatable)
        # Tab four: back up target & insert data table
                # Allow rollback



### phase 01: STUDIO LOOKUP
### Take user input for source CID (site ID), dbShort, and server. Validate.
### Then take user input for target CID (site ID), dbShort, and server. Validate.

### phase 02: CREATE SOURCE
### backup source clients & CCs
### build new table (or datatable) to be transferred

### phase 03: INSERT TARGET
### backup target clients & CCs
### update ClientIDs as needed
### insert Source table into clients


### POST FUNCTIONAL TWEAKS
### allow user to choose which clients they want included
### allow user to choose if they want passwords and/or CCs
### create template email to be sent to client

