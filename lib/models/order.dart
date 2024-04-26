// package models

// import (
// 	"time"

// 	"gorm.io/gorm"
// )

// type Progress string

// const (
// 	ProgressPending   Progress = "Pending"
// 	ProgressAccepted  Progress = "Accepted"
// 	ProgressRejected  Progress = "Rejected"
// 	ProgressCompleted Progress = "Completed"
// )

// type Order struct {
// 	gorm.Model
// 	UserId int `json:"user_id"`

// 	PostId         int       `json:"post_id"`
// 	Quantity       int       `json:"quantity"`
// 	Progress       Progress  `json:"progress" gorm:"default:Pending"`
// 	ManufacturerId int       `json:"manufacturer_id"`
// 	Date           time.Time `json:"date"`
// }
enum Progress {
  pending,
  accepted,
  rejected,
  completed,
}

class Order {
  int id;
  int userId;
  int postId;
  int quantity;
  Progress progress;
  int manufacturerId;
  DateTime date;

  Order({
    required this.id,
    required this.userId,
    required this.postId,
    required this.quantity,
    required this.progress,
    required this.manufacturerId,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      quantity: json['quantity'],
      progress: json['progress'],
      manufacturerId: json['manufacturer_id'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'quantity': quantity,
      'progress': progress,
      'manufacturer_id': manufacturerId,
      'date': date.toIso8601String(),
    };
  }
}
