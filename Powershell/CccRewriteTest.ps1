. .\SqlVariables.ps1



### phase 01: STUDIO LOOKUP
### Take user input for source CID (site ID), dbShort, and server. Validate.
### Then take user input for target CID (site ID), dbShort, and server. Validate.


### phase 01a: CHOOSE CRITERIA
### select one of a given list of special criteria  / start with 'none' or 'homestudio=2'
### select scope: PWs? CCs? (GUI: drop-down menu; default of "both")


### phase 02: TARGET SITE

## Gather basic information & present to user
        # number of CCs
        # number of PWs

## Backup source table(s)

## Get decryption
        # Verify decryption was successful

## Create Source tables

## Re-encrypt

##----------------------MOVE TO TARGET-------------------------

### phase 03: TARGET
## find 

## Update IDs to avoid collisions
        # add clause to avoid updating custom RSSIDs that don't exist in target site

## Backup target table(s)

## Get decryption

## Insert source table(s)

## Re-encrypt

## Drop tables