package controllers

import (
	"errors"
	"net/http"
	"{{.ModulePath}}/app/models"
	"{{.ModulePath}}/internal/responses"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// {{.ModelName}}Controller handles {{.ModelName}}-related requests.
type {{.ModelName}}Controller struct {
	DB *gorm.DB
}

// GetAll{{.ModelNamePlural}} retrieves all {{.TableName}} from the database.
// @Summary Get all {{.TableName}}
// @Description Retrieve a list of all {{.TableName}}
// @Tags {{.TableName}}
// @Accept json
// @Produce json
// @Success 200 {array} models.{{.ModelName}}
// @Failure 500 {object} responses.ErrorResponse
// @Router /{{.TableName}} [get]
func (ctrl *{{.ModelName}}Controller) GetAll{{.ModelNamePlural}}(c *gin.Context) {
	var records []models.{{.ModelName}}
	if err := ctrl.DB.Find(&records).Error; err != nil {
		c.JSON(http.StatusInternalServerError, responses.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, records)
}

// Get{{.ModelName}}ByID retrieves a {{.ModelName}} by its ID.
// @Summary Get {{.ModelName}} by ID
// @Description Retrieve a {{.ModelName}} record by its ID
// @Tags {{.TableName}}
// @Accept json
// @Produce json
// @Param id path int true "{{.ModelName}} ID"
// @Success 200 {object} models.{{.ModelName}}
// @Failure 404 {object} responses.ErrorResponse
// @Router /{{.TableName}}/{id} [get]
func (ctrl *{{.ModelName}}Controller) Get{{.ModelName}}ByID(c *gin.Context) {
	var record models.{{.ModelName}}
	id := c.Param("id")
	if id == "" {
		c.JSON(http.StatusBadRequest, responses.ErrorResponse{Error: "ID parameter is required"})
		return
	}
	if err := ctrl.DB.First(&record, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, responses.ErrorResponse{Error: "{{.ModelName}} not found"})
		} else {
			c.JSON(http.StatusInternalServerError, responses.ErrorResponse{Error: err.Error()})
		}
		return
	}
	c.JSON(http.StatusOK, record)
}

// Create{{.ModelName}} creates a new {{.ModelName}} record.
// @Summary Create a new {{.ModelName}}
// @Description Create a new {{.ModelName}} record
// @Tags {{.TableName}}
// @Accept json
// @Produce json
// @Param {{.TableName}} body models.{{.ModelName}} true "{{.ModelName}} to create"
// @Success 201 {object} models.{{.ModelName}}
// @Failure 400 {object} responses.ErrorResponse
// @Failure 500 {object} responses.ErrorResponse
// @Router /{{.TableName}} [post]
func (ctrl *{{.ModelName}}Controller) Create{{.ModelName}}(c *gin.Context) {
	var record models.{{.ModelName}}
	if err := c.ShouldBindJSON(&record); err != nil {
		c.JSON(http.StatusBadRequest, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := record.Validate(); err != nil {
		c.JSON(http.StatusBadRequest, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := ctrl.DB.Create(&record).Error; err != nil {
		c.JSON(http.StatusInternalServerError, responses.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusCreated, record)
}

// Update{{.ModelName}} updates an existing {{.ModelName}} record.
// @Summary Update an existing {{.ModelName}}
// @Description Update a {{.ModelName}} record by ID
// @Tags {{.TableName}}
// @Accept json
// @Produce json
// @Param id path int true "{{.ModelName}} ID"
// @Param {{.TableName}} body models.{{.ModelName}} true "{{.ModelName}} to update"
// @Success 200 {object} models.{{.ModelName}}
// @Failure 400 {object} responses.ErrorResponse
// @Failure 404 {object} responses.ErrorResponse
// @Failure 500 {object} responses.ErrorResponse
// @Router /{{.TableName}}/{id} [put]
func (ctrl *{{.ModelName}}Controller) Update{{.ModelName}}(c *gin.Context) {
	var record models.{{.ModelName}}
	id := c.Param("id")

	if err := ctrl.DB.First(&record, id).Error; err != nil {
		c.JSON(http.StatusNotFound, responses.ErrorResponse{Error: "{{.ModelName}} not found"})
		return
	}

	if err := c.ShouldBindJSON(&record); err != nil {
		c.JSON(http.StatusBadRequest, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := record.Validate(); err != nil {
		c.JSON(http.StatusBadRequest, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := ctrl.DB.Save(&record).Error; err != nil {
		c.JSON(http.StatusInternalServerError, responses.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, record)
}

// Delete{{.ModelName}} deletes a {{.ModelName}} record.
// @Summary Delete a {{.ModelName}}
func (ctrl *{{.ModelName}}Controller) Delete{{.ModelName}}(c *gin.Context) {
	var record models.{{.ModelName}}
	id := c.Param("id")

	if id == "" {
		c.JSON(http.StatusBadRequest, responses.ErrorResponse{Error: "ID parameter is required"})
		return
	}

	if err := ctrl.DB.First(&record, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, responses.ErrorResponse{Error: "{{.ModelName}} not found"})
		} else {
			c.JSON(http.StatusInternalServerError, responses.ErrorResponse{Error: err.Error()})
		}
		return
	}

	if err := ctrl.DB.Delete(&record).Error; err != nil {
		c.JSON(http.StatusInternalServerError, responses.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "{{.ModelName}} deleted"})
}
