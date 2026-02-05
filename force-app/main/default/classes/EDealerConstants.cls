/****
 *  Name        :   EDealerConstants
 *  Description :   This Used for saving all the contant / harcoded values which will be used at all places, 
                    so that if any change in future we can change at 1 place only
***/
public without sharing class EDealerConstants {
    
    //Suggested Orders 
    public static final String SO_PART_CATEGORY_TYPE_DSP = 'DSP';
    public static final String SO_PART_CATEGORY_TYPE_DUAL = 'DUAL';
	public static final String SO_PART_CATEGORY_TYPE_EM = 'EM';
    public static final String SO_PART_CATEGORY_TYPE_PDC = 'PDC';
    public static final String SO_PART_CATEGORY_TYPE_NONPACCAR = 'ENG';
    public static final String SO_TYPE_SOF = 'SOF';
    public static final String SO_TYPE_MasterInventory = 'Master Inventory';
    
    //Cart
    public static final String CART_ORDER_TYPE_EMERGENCY = 'Emergency Order';
    public static final String CART_ORDER_TYPE_STOCK = 'Stock Order';
    public static final String CART_ORDER_TYPE_DSP = 'DSP Order';
    public static final String CART_ORDER_TYPE_DSP_EMERGENCY = 'DSP Emergency Order';
    public static final String CART_TYPE_CART = 'In Cart';
    public static final String CART_TYPE_PLACED = 'Order Placed';
    
    //for api logs
    public static string APIERRORLOG = 'API Error';
    public static string APIEXCEPTIONLOG = 'Apex Exception';
    public static string APICACHELOG = 'Cache API Response';
    
    //DBS names
    public static final String DBS_DSI = 'DSI';
}