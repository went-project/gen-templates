package models

import (
	"time"

	"{{.ModulePath}}/internal/utils"

	"github.com/go-playground/validator/v10"
	"gorm.io/gorm"
)

// {{.ModelName}} represents a {{.ModelName | ToLower}} entity in the system.
type {{.ModelName}} struct {
	ID        uint           `gorm:"primaryKey" json:"id" swaggerignore:"true"`
	// Add your custom fields below ↓↓↓
	// ExampleField string `gorm:"not null" json:"example_field" validate:"required_if=ID 0" example:"example value"`
	CreatedAt time.Time      `json:"created_at" swaggerignore:"true"`
	UpdatedAt time.Time      `json:"updated_at" swaggerignore:"true"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-" swaggerignore:"true"`
}

// HiddenFields specifies fields to omit in JSON responses
var HiddenFields = []string{
	"deleted_at",
}

// TableName sets the insert table name for this struct type
func ({{.ModelName}}) TableName() string {
	return "{{.TableName}}"
}

// Validate validates the model fields.
func (m *{{.ModelName}}) Validate() error {
	err := validator.New().Struct(m)
	if err != nil {
		return err
	}
	return nil
}

// BeforeCreate is a GORM hook called before a new record is inserted into the database.
func (m *{{.ModelName}}) BeforeCreate(tx *gorm.DB) (err error) {
	// Before actions...
	return
}

// BeforeUpdate is a GORM hook called before an existing record is updated.
func (m *{{.ModelName}}) BeforeUpdate(tx *gorm.DB) (err error) {
    // Before actions...
	return
}

// CRUD Operations
func (m *{{.ModelName}}) FindAll(db *gorm.DB, where map[string]interface{}) ([]{{.ModelName}}, error) {
	var records []{{.ModelName}}
	err := db.Select("*").Omit(HiddenFields...).Where(where).Find(&records).Error
	return records, err
}

func (m *{{.ModelName}}) Create(db *gorm.DB) error {
	return db.Create(m).Error
}

func (m *{{.ModelName}}) Update(db *gorm.DB) error {
	return db.Save(m).Error
}

func (m *{{.ModelName}}) Delete(db *gorm.DB) error {
	return db.Delete(m).Error
}
