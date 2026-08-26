import 'dart:convert';

/// Represents the API response for restaurant items.
class ItemsListResponse {
  int? status;
  String? message;
  List<RestaurantItem>? data;
  Pagination? pagination;

  ItemsListResponse({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory ItemsListResponse.fromRawJson(String str) =>
      ItemsListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemsListResponse.fromJson(Map<String, dynamic> json) =>
      ItemsListResponse(
        status: (json["status"] as num?)?.toInt(),
        message: json["message"]?.toString() ?? "",
        data: json["data"] != null
            ? List<RestaurantItem>.from(
                (json["data"] as List).map((x) => RestaurantItem.fromJson(x)))
            : [],
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
        "pagination": pagination?.toJson(),
      };
}

/// Represents a single restaurant item.
class RestaurantItem {
  int? id;
  String? uuId;
  String? code;
  String? itemName;
  double? salePrice;
  double? packingCharges;
  int? maxOrderQuantity;
  String? cuisineType;
  String? description;
  int? preparationTime;
  bool? itemStatus;
  bool? isApproved;
  bool? isActive;
  double? avgRating;
  int? totalReviews;
  String? createdAt;
  Vendor? vendor;
  MenuCategory? menuCategory;
  List<ItemImage>? images;

  RestaurantItem({
    this.id,
    this.uuId,
    this.code,
    this.itemName,
    this.salePrice,
    this.packingCharges,
    this.maxOrderQuantity,
    this.cuisineType,
    this.description,
    this.preparationTime,
    this.itemStatus,
    this.isApproved,
    this.isActive,
    this.avgRating,
    this.totalReviews,
    this.createdAt,
    this.vendor,
    this.menuCategory,
    this.images,
  });

  factory RestaurantItem.fromRawJson(String str) =>
      RestaurantItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantItem.fromJson(Map<String, dynamic> json) => RestaurantItem(
        id: (json["id"] as num?)?.toInt(),
        uuId: json["uu_id"]?.toString() ?? "",
        code: json["code"]?.toString() ?? "",
        itemName: json["item_name"]?.toString() ?? "",
        salePrice: (json["sale_price"] as num?)?.toDouble() ?? 0.0,
        packingCharges: (json["packing_charges"] as num?)?.toDouble() ?? 0.0,
        maxOrderQuantity: (json["max_order_quantity"] as num?)?.toInt() ?? 0,
        cuisineType: json["cuisine_type"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        preparationTime: (json["preparation_time"] as num?)?.toInt() ?? 0,
        itemStatus: json["item_status"] as bool? ?? false,
        isApproved: json["is_approved"] as bool? ?? false,
        isActive: json["is_active"] as bool? ?? false,
        avgRating: (json["avg_rating"] as num?)?.toDouble() ?? 0.0,
        totalReviews: (json["total_reviews"] as num?)?.toInt() ?? 0,
        createdAt: json["created_at"]?.toString() ?? "",
        vendor: json["vendor"] != null && json["vendor"] is Map<String, dynamic>
            ? Vendor.fromJson(json["vendor"])
            : null,
        menuCategory: json["menu_category"] != null &&
                json["menu_category"] is Map<String, dynamic>
            ? MenuCategory.fromJson(json["menu_category"])
            : null,
        images: json["images"] != null && json["images"] is List
            ? List<ItemImage>.from(
                (json["images"] as List).map((x) => ItemImage.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uu_id": uuId,
        "code": code,
        "item_name": itemName,
        "sale_price": salePrice,
        "packing_charges": packingCharges,
        "max_order_quantity": maxOrderQuantity,
        "cuisine_type": cuisineType,
        "description": description,
        "preparation_time": preparationTime,
        "item_status": itemStatus,
        "is_approved": isApproved,
        "is_active": isActive,
        "avg_rating": avgRating,
        "total_reviews": totalReviews,
        "created_at": createdAt,
        "vendor": vendor?.toJson(),
        "menu_category": menuCategory?.toJson(),
        "images": images != null
            ? List<dynamic>.from(images!.map((x) => x.toJson()))
            : [],
      };
}

/// Represents vendor details.
class Vendor {
  int? id;
  String? entityName;
  double? avgRating;
  int? totalReviews;

  Vendor({
    this.id,
    this.entityName,
    this.avgRating,
    this.totalReviews,
  });

  factory Vendor.fromRawJson(String str) => Vendor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: (json["id"] as num?)?.toInt(),
        entityName: json["entity_name"]?.toString() ?? "",
        avgRating: (json["avg_rating"] as num?)?.toDouble() ?? 0.0,
        totalReviews: (json["total_reviews"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity_name": entityName,
        "avg_rating": avgRating,
        "total_reviews": totalReviews,
      };
}

/// Represents menu category details.
class MenuCategory {
  int? id;
  String? menuCategoryName;

  MenuCategory({
    this.id,
    this.menuCategoryName,
  });

  factory MenuCategory.fromRawJson(String str) =>
      MenuCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        id: (json["id"] as num?)?.toInt(),
        menuCategoryName: json["menu_category_name"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "menu_category_name": menuCategoryName,
      };
}

/// Represents item image details.
class ItemImage {
  int? id;
  String? itemImage;
  bool? isPrimary;
  bool? isActive;

  ItemImage({
    this.id,
    this.itemImage,
    this.isPrimary,
    this.isActive,
  });

  factory ItemImage.fromRawJson(String str) =>
      ItemImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
        id: (json["id"] as num?)?.toInt(),
        itemImage: json["item_image"]?.toString() ?? "",
        isPrimary: json["is_primary"] as bool? ?? false,
        isActive: json["is_active"] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_image": itemImage,
        "is_primary": isPrimary,
        "is_active": isActive,
      };
}

/// Represents pagination details.
class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: (json["total"] as num?)?.toInt() ?? 0,
        perPage: (json["per_page"] as num?)?.toInt() ?? 0,
        currentPage: (json["current_page"] as num?)?.toInt() ?? 0,
        totalPages: (json["total_pages"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}
