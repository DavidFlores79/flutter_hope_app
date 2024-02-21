// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 20/02/2024
 */
import 'dart:convert';

class SBO_ItemsResponse {
  String? odataMetadata;
  List<SBO_Item>? value;
  String? odataNextLink;

  SBO_ItemsResponse({
    this.odataMetadata,
    this.value,
    this.odataNextLink,
  });

  factory SBO_ItemsResponse.fromJson(String str) =>
      SBO_ItemsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SBO_ItemsResponse.fromMap(Map<String, dynamic> json) =>
      SBO_ItemsResponse(
        odataMetadata: json["odata.metadata"],
        value: json["value"] == null
            ? []
            : List<SBO_Item>.from(
                json["value"]!.map((x) => SBO_Item.fromMap(x))),
        odataNextLink: json["odata.nextLink"],
      );

  Map<String, dynamic> toMap() => {
        "odata.metadata": odataMetadata,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toMap())),
        "odata.nextLink": odataNextLink,
      };
}

class SBO_Item {
  String? odataEtag;
  String? itemCode;
  String? itemName;
  String? inventoryUOM;
  dynamic foreignName;
  String? itemType;
  String? assetStatus;
  String? inCostRollup;
  List<ItemPrice>? itemPrices;
  List<ItemWarehouseInfoCollection>? itemWarehouseInfoCollection;

  SBO_Item({
    this.odataEtag,
    this.itemCode,
    this.itemName,
    this.inventoryUOM,
    this.foreignName,
    this.itemType,
    this.assetStatus,
    this.inCostRollup,
    this.itemPrices,
    this.itemWarehouseInfoCollection,
  });

  factory SBO_Item.fromJson(String str) => SBO_Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SBO_Item.fromMap(Map<String, dynamic> json) => SBO_Item(
        odataEtag: json["odata.etag"],
        itemCode: json["ItemCode"],
        itemName: json["ItemName"],
        inventoryUOM: json["InventoryUOM"],
        foreignName: json["ForeignName"],
        itemType: json["ItemType"],
        assetStatus: json["AssetStatus"],
        inCostRollup: json["InCostRollup"],
        itemPrices: json["ItemPrices"] == null
            ? []
            : List<ItemPrice>.from(
                json["ItemPrices"]!.map((x) => ItemPrice.fromMap(x))),
        itemWarehouseInfoCollection: json["ItemWarehouseInfoCollection"] == null
            ? []
            : List<ItemWarehouseInfoCollection>.from(
                json["ItemWarehouseInfoCollection"]!
                    .map((x) => ItemWarehouseInfoCollection.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "odata.etag": odataEtag,
        "ItemCode": itemCode,
        "InventoryUOM": inventoryUOM,
        "ForeignName": foreignName,
        "ItemType": itemType,
        "AssetStatus": assetStatus,
        "InCostRollup": inCostRollup,
        "ItemPrices": itemPrices == null
            ? []
            : List<dynamic>.from(itemPrices!.map((x) => x.toMap())),
        "ItemWarehouseInfoCollection": itemWarehouseInfoCollection == null
            ? []
            : List<dynamic>.from(
                itemWarehouseInfoCollection!.map((x) => x.toMap())),
      };
}

class ItemPrice {
  int? priceList;
  double? price;
  String? currency;
  int? additionalPrice1;
  String? additionalCurrency1;
  int? additionalPrice2;
  String? additionalCurrency2;
  int? basePriceList;
  int? factor;
  List<dynamic>? uoMPrices;

  ItemPrice({
    this.priceList,
    this.price,
    this.currency,
    this.additionalPrice1,
    this.additionalCurrency1,
    this.additionalPrice2,
    this.additionalCurrency2,
    this.basePriceList,
    this.factor,
    this.uoMPrices,
  });

  factory ItemPrice.fromJson(String str) => ItemPrice.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemPrice.fromMap(Map<String, dynamic> json) => ItemPrice(
        priceList: json["PriceList"],
        price: json["Price"]?.toDouble(),
        currency: json["Currency"],
        additionalPrice1: json["AdditionalPrice1"],
        additionalCurrency1: json["AdditionalCurrency1"],
        additionalPrice2: json["AdditionalPrice2"],
        additionalCurrency2: json["AdditionalCurrency2"],
        basePriceList: json["BasePriceList"],
        factor: json["Factor"],
        uoMPrices: json["UoMPrices"] == null
            ? []
            : List<dynamic>.from(json["UoMPrices"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "PriceList": priceList,
        "Price": price,
        "Currency": currency,
        "AdditionalPrice1": additionalPrice1,
        "AdditionalCurrency1": additionalCurrency1,
        "AdditionalPrice2": additionalPrice2,
        "AdditionalCurrency2": additionalCurrency2,
        "BasePriceList": basePriceList,
        "Factor": factor,
        "UoMPrices": uoMPrices == null
            ? []
            : List<dynamic>.from(uoMPrices!.map((x) => x)),
      };
}

class ItemWarehouseInfoCollection {
  int? minimalStock;
  int? maximalStock;
  int? minimalOrder;
  double? standardAveragePrice;
  String? locked;
  dynamic inventoryAccount;
  dynamic costAccount;
  dynamic transferAccount;
  dynamic revenuesAccount;
  dynamic varienceAccount;
  dynamic decreasingAccount;
  dynamic increasingAccount;
  dynamic returningAccount;
  dynamic expensesAccount;
  dynamic euRevenuesAccount;
  dynamic euExpensesAccount;
  dynamic foreignRevenueAcc;
  dynamic foreignExpensAcc;
  dynamic exemptIncomeAcc;
  dynamic priceDifferenceAcc;
  String? warehouseCode;
  double? inStock;
  double? committed;
  double? ordered;
  int? countedQuantity;
  String? wasCounted;
  int? userSignature;
  int? counted;
  dynamic expenseClearingAct;
  dynamic purchaseCreditAcc;
  dynamic euPurchaseCreditAcc;
  dynamic foreignPurchaseCreditAcc;
  dynamic salesCreditAcc;
  dynamic salesCreditEuAcc;
  dynamic exemptedCredits;
  dynamic salesCreditForeignAcc;
  dynamic expenseOffsettingAccount;
  dynamic wipAccount;
  dynamic exchangeRateDifferencesAcct;
  dynamic goodsClearingAcct;
  dynamic negativeInventoryAdjustmentAccount;
  dynamic costInflationOffsetAccount;
  dynamic glDecreaseAcct;
  dynamic glIncreaseAcct;
  dynamic paReturnAcct;
  dynamic purchaseAcct;
  dynamic purchaseOffsetAcct;
  dynamic shippedGoodsAccount;
  dynamic stockInflationOffsetAccount;
  dynamic stockInflationAdjustAccount;
  dynamic vatInRevenueAccount;
  dynamic wipVarianceAccount;
  dynamic costInflationAccount;
  dynamic whIncomingCenvatAccount;
  dynamic whOutgoingCenvatAccount;
  dynamic stockInTransitAccount;
  dynamic wipOffsetProfitAndLossAccount;
  dynamic inventoryOffsetProfitAndLossAccount;
  int? defaultBin;
  String? defaultBinEnforced;
  dynamic purchaseBalanceAccount;
  String? itemCode;
  String? indEscala;
  dynamic cnjpMan;
  List<dynamic>? itemCycleCounts;

  ItemWarehouseInfoCollection({
    this.minimalStock,
    this.maximalStock,
    this.minimalOrder,
    this.standardAveragePrice,
    this.locked,
    this.inventoryAccount,
    this.costAccount,
    this.transferAccount,
    this.revenuesAccount,
    this.varienceAccount,
    this.decreasingAccount,
    this.increasingAccount,
    this.returningAccount,
    this.expensesAccount,
    this.euRevenuesAccount,
    this.euExpensesAccount,
    this.foreignRevenueAcc,
    this.foreignExpensAcc,
    this.exemptIncomeAcc,
    this.priceDifferenceAcc,
    this.warehouseCode,
    this.inStock,
    this.committed,
    this.ordered,
    this.countedQuantity,
    this.wasCounted,
    this.userSignature,
    this.counted,
    this.expenseClearingAct,
    this.purchaseCreditAcc,
    this.euPurchaseCreditAcc,
    this.foreignPurchaseCreditAcc,
    this.salesCreditAcc,
    this.salesCreditEuAcc,
    this.exemptedCredits,
    this.salesCreditForeignAcc,
    this.expenseOffsettingAccount,
    this.wipAccount,
    this.exchangeRateDifferencesAcct,
    this.goodsClearingAcct,
    this.negativeInventoryAdjustmentAccount,
    this.costInflationOffsetAccount,
    this.glDecreaseAcct,
    this.glIncreaseAcct,
    this.paReturnAcct,
    this.purchaseAcct,
    this.purchaseOffsetAcct,
    this.shippedGoodsAccount,
    this.stockInflationOffsetAccount,
    this.stockInflationAdjustAccount,
    this.vatInRevenueAccount,
    this.wipVarianceAccount,
    this.costInflationAccount,
    this.whIncomingCenvatAccount,
    this.whOutgoingCenvatAccount,
    this.stockInTransitAccount,
    this.wipOffsetProfitAndLossAccount,
    this.inventoryOffsetProfitAndLossAccount,
    this.defaultBin,
    this.defaultBinEnforced,
    this.purchaseBalanceAccount,
    this.itemCode,
    this.indEscala,
    this.cnjpMan,
    this.itemCycleCounts,
  });

  factory ItemWarehouseInfoCollection.fromJson(String str) =>
      ItemWarehouseInfoCollection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemWarehouseInfoCollection.fromMap(Map<String, dynamic> json) =>
      ItemWarehouseInfoCollection(
        minimalStock: json["MinimalStock"],
        maximalStock: json["MaximalStock"],
        minimalOrder: json["MinimalOrder"],
        standardAveragePrice: json["StandardAveragePrice"]?.toDouble(),
        locked: json["Locked"],
        inventoryAccount: json["InventoryAccount"],
        costAccount: json["CostAccount"],
        transferAccount: json["TransferAccount"],
        revenuesAccount: json["RevenuesAccount"],
        varienceAccount: json["VarienceAccount"],
        decreasingAccount: json["DecreasingAccount"],
        increasingAccount: json["IncreasingAccount"],
        returningAccount: json["ReturningAccount"],
        expensesAccount: json["ExpensesAccount"],
        euRevenuesAccount: json["EURevenuesAccount"],
        euExpensesAccount: json["EUExpensesAccount"],
        foreignRevenueAcc: json["ForeignRevenueAcc"],
        foreignExpensAcc: json["ForeignExpensAcc"],
        exemptIncomeAcc: json["ExemptIncomeAcc"],
        priceDifferenceAcc: json["PriceDifferenceAcc"],
        warehouseCode: json["WarehouseCode"],
        inStock: json["InStock"]?.toDouble(),
        committed: json["Committed"]?.toDouble(),
        ordered: json["Ordered"]?.toDouble(),
        countedQuantity: json["CountedQuantity"],
        wasCounted: json["WasCounted"],
        userSignature: json["UserSignature"],
        counted: json["Counted"],
        expenseClearingAct: json["ExpenseClearingAct"],
        purchaseCreditAcc: json["PurchaseCreditAcc"],
        euPurchaseCreditAcc: json["EUPurchaseCreditAcc"],
        foreignPurchaseCreditAcc: json["ForeignPurchaseCreditAcc"],
        salesCreditAcc: json["SalesCreditAcc"],
        salesCreditEuAcc: json["SalesCreditEUAcc"],
        exemptedCredits: json["ExemptedCredits"],
        salesCreditForeignAcc: json["SalesCreditForeignAcc"],
        expenseOffsettingAccount: json["ExpenseOffsettingAccount"],
        wipAccount: json["WipAccount"],
        exchangeRateDifferencesAcct: json["ExchangeRateDifferencesAcct"],
        goodsClearingAcct: json["GoodsClearingAcct"],
        negativeInventoryAdjustmentAccount:
            json["NegativeInventoryAdjustmentAccount"],
        costInflationOffsetAccount: json["CostInflationOffsetAccount"],
        glDecreaseAcct: json["GLDecreaseAcct"],
        glIncreaseAcct: json["GLIncreaseAcct"],
        paReturnAcct: json["PAReturnAcct"],
        purchaseAcct: json["PurchaseAcct"],
        purchaseOffsetAcct: json["PurchaseOffsetAcct"],
        shippedGoodsAccount: json["ShippedGoodsAccount"],
        stockInflationOffsetAccount: json["StockInflationOffsetAccount"],
        stockInflationAdjustAccount: json["StockInflationAdjustAccount"],
        vatInRevenueAccount: json["VATInRevenueAccount"],
        wipVarianceAccount: json["WipVarianceAccount"],
        costInflationAccount: json["CostInflationAccount"],
        whIncomingCenvatAccount: json["WHIncomingCenvatAccount"],
        whOutgoingCenvatAccount: json["WHOutgoingCenvatAccount"],
        stockInTransitAccount: json["StockInTransitAccount"],
        wipOffsetProfitAndLossAccount: json["WipOffsetProfitAndLossAccount"],
        inventoryOffsetProfitAndLossAccount:
            json["InventoryOffsetProfitAndLossAccount"],
        defaultBin: json["DefaultBin"],
        defaultBinEnforced: json["DefaultBinEnforced"],
        purchaseBalanceAccount: json["PurchaseBalanceAccount"],
        itemCode: json["ItemCode"],
        indEscala: json["IndEscala"],
        cnjpMan: json["CNJPMan"],
        itemCycleCounts: json["ItemCycleCounts"] == null
            ? []
            : List<dynamic>.from(json["ItemCycleCounts"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "MinimalStock": minimalStock,
        "MaximalStock": maximalStock,
        "MinimalOrder": minimalOrder,
        "StandardAveragePrice": standardAveragePrice,
        "Locked": locked,
        "InventoryAccount": inventoryAccount,
        "CostAccount": costAccount,
        "TransferAccount": transferAccount,
        "RevenuesAccount": revenuesAccount,
        "VarienceAccount": varienceAccount,
        "DecreasingAccount": decreasingAccount,
        "IncreasingAccount": increasingAccount,
        "ReturningAccount": returningAccount,
        "ExpensesAccount": expensesAccount,
        "EURevenuesAccount": euRevenuesAccount,
        "EUExpensesAccount": euExpensesAccount,
        "ForeignRevenueAcc": foreignRevenueAcc,
        "ForeignExpensAcc": foreignExpensAcc,
        "ExemptIncomeAcc": exemptIncomeAcc,
        "PriceDifferenceAcc": priceDifferenceAcc,
        "WarehouseCode": warehouseCode,
        "InStock": inStock,
        "Committed": committed,
        "Ordered": ordered,
        "CountedQuantity": countedQuantity,
        "WasCounted": wasCounted,
        "UserSignature": userSignature,
        "Counted": counted,
        "ExpenseClearingAct": expenseClearingAct,
        "PurchaseCreditAcc": purchaseCreditAcc,
        "EUPurchaseCreditAcc": euPurchaseCreditAcc,
        "ForeignPurchaseCreditAcc": foreignPurchaseCreditAcc,
        "SalesCreditAcc": salesCreditAcc,
        "SalesCreditEUAcc": salesCreditEuAcc,
        "ExemptedCredits": exemptedCredits,
        "SalesCreditForeignAcc": salesCreditForeignAcc,
        "ExpenseOffsettingAccount": expenseOffsettingAccount,
        "WipAccount": wipAccount,
        "ExchangeRateDifferencesAcct": exchangeRateDifferencesAcct,
        "GoodsClearingAcct": goodsClearingAcct,
        "NegativeInventoryAdjustmentAccount":
            negativeInventoryAdjustmentAccount,
        "CostInflationOffsetAccount": costInflationOffsetAccount,
        "GLDecreaseAcct": glDecreaseAcct,
        "GLIncreaseAcct": glIncreaseAcct,
        "PAReturnAcct": paReturnAcct,
        "PurchaseAcct": purchaseAcct,
        "PurchaseOffsetAcct": purchaseOffsetAcct,
        "ShippedGoodsAccount": shippedGoodsAccount,
        "StockInflationOffsetAccount": stockInflationOffsetAccount,
        "StockInflationAdjustAccount": stockInflationAdjustAccount,
        "VATInRevenueAccount": vatInRevenueAccount,
        "WipVarianceAccount": wipVarianceAccount,
        "CostInflationAccount": costInflationAccount,
        "WHIncomingCenvatAccount": whIncomingCenvatAccount,
        "WHOutgoingCenvatAccount": whOutgoingCenvatAccount,
        "StockInTransitAccount": stockInTransitAccount,
        "WipOffsetProfitAndLossAccount": wipOffsetProfitAndLossAccount,
        "InventoryOffsetProfitAndLossAccount":
            inventoryOffsetProfitAndLossAccount,
        "DefaultBin": defaultBin,
        "DefaultBinEnforced": defaultBinEnforced,
        "PurchaseBalanceAccount": purchaseBalanceAccount,
        "ItemCode": itemCode,
        "IndEscala": indEscala,
        "CNJPMan": cnjpMan,
        "ItemCycleCounts": itemCycleCounts == null
            ? []
            : List<dynamic>.from(itemCycleCounts!.map((x) => x)),
      };
}
