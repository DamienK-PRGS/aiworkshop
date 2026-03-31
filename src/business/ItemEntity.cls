/*------------------------------------------------------------------------
  File        : ItemEntity
  Purpose     : Business entity for Item data access
  Syntax      : 
  Description : Encapsulates all data operations for the Item entity
  Author(s)   : 
  Created     : Tue Mar 31 2025
  Notes       : 
----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS business.ItemEntity INHERITS BusinessEntity USE-WIDGET-POOL:
    
    /* Include dataset definition */
    {business/ItemDataset.i}
    
    /* Define data source for Item table */
    DEFINE DATA-SOURCE srcItem FOR Item.
    
    /*------------------------------------------------------------------------------
     Purpose: Constructor for ItemEntity
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ItemEntity():
        /* Pass dataset handle to parent class */
        SUPER(DATASET dsItem:HANDLE).

        /* Create array of data source handles */
        VAR HANDLE[1] hDataSourceArray = DATA-SOURCE srcItem:HANDLE.
        VAR CHARACTER[1] cSkipListArray = [""].
        
        /* Set parent class properties */
        THIS-OBJECT:ProDataSource = hDataSourceArray.
        THIS-OBJECT:SkipList = cSkipListArray.
    END CONSTRUCTOR.
    
    /*------------------------------------------------------------------------------
     Purpose: Get Item by ItemNum
     Notes: Returns TRUE if item found, FALSE otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL GetItemByNumber(INPUT ipiItemNum AS INTEGER,
                                         OUTPUT DATASET dsItem):
        VAR CHARACTER cFilter.
        VAR LOGICAL lFound = FALSE.
        
        /* Build WHERE clause for database query */
        cFilter = "WHERE Item.ItemNum = " + STRING(ipiItemNum).
        
        /* Parent class ReadData() executes query and fills temp-table */
        THIS-OBJECT:ReadData(cFilter).

        /* Check if data was found */
        lFound = CAN-FIND(FIRST ttItem).
        
        RETURN lFound.
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: Update Item
     Notes: Updates existing Item record in database
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID UpdateItem(INPUT-OUTPUT DATASET dsItem):
        /* Parent class detects changes and updates database */
        THIS-OBJECT:UpdateData(DATASET dsItem BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: Validate Item data
     Notes: Validates business rules for Item data
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL ValidateItem(INPUT-OUTPUT DATASET dsItem,
                                      OUTPUT errorMessage AS CHARACTER):
        VAR LOGICAL isValid = TRUE.
        VAR DECIMAL dTotal.
        
        /* Find the record to validate */
        FIND FIRST ttItem NO-ERROR.
        IF AVAILABLE ttItem THEN DO:
            /* Check business rules */
            IF ttItem.Price = 0 THEN DO:
                isValid = FALSE.
                errorMessage = "Price cannot be empty".
                RETURN isValid.
            END.
            
            /* Calculate total value and check business rule */
            dTotal = ttItem.OnHand * ttItem.Price.
            IF dTotal > 6000 THEN DO:
                isValid = FALSE.
                errorMessage = "Total value onhand will be " + STRING(dTotal) + 
                              ", should not be larger than 6000".
                RETURN isValid.
            END.
        END.
        
        RETURN isValid.
    END METHOD.
    
END CLASS.