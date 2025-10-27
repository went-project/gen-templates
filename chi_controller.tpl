package controllers

import (
	"encoding/json"
	"errors"
	"net/http"
	"{{.ModulePath}}/app/models"
	"{{.ModulePath}}/internal/responses"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/render"
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
func (c *{{.ModelName}}Controller) GetAll{{.ModelNamePlural}}(w http.ResponseWriter, r *http.Request) {
	var records []models.{{.ModelName}}
	if err := c.DB.Find(&records).Error; err != nil {
		render.Status(r, http.StatusInternalServerError)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}
	render.JSON(w, r, records)
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
func (c *{{.ModelName}}Controller) Get{{.ModelName}}ByID(w http.ResponseWriter, r *http.Request) {
	var record models.{{.ModelName}}
	id := chi.URLParam(r, "id")
	if id == "" {
		render.Status(r, http.StatusBadRequest)
		render.JSON(w, r, responses.ErrorResponse{Error: "ID parameter is required"})
		return
	}
	if err := c.DB.First(&record, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			render.Status(r, http.StatusNotFound)
			render.JSON(w, r, responses.ErrorResponse{Error: "{{.ModelName}} not found"})
		} else {
			render.Status(r, http.StatusInternalServerError)
			render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		}
		return
	}
	render.JSON(w, r, record)
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
func (c *{{.ModelName}}Controller) Create{{.ModelName}}(w http.ResponseWriter, r *http.Request) {
	var record models.{{.ModelName}}
	if err := json.NewDecoder(r.Body).Decode(&record); err != nil {
		render.Status(r, http.StatusBadRequest)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := record.Validate(); err != nil {
		render.Status(r, http.StatusBadRequest)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := c.DB.Create(&record).Error; err != nil {
		render.Status(r, http.StatusInternalServerError)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}
	render.Status(r, http.StatusCreated)
	render.JSON(w, r, record)
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
func (c *{{.ModelName}}Controller) Update{{.ModelName}}(w http.ResponseWriter, r *http.Request) {
	var record models.{{.ModelName}}
	id := chi.URLParam(r, "id")

	if err := c.DB.First(&record, id).Error; err != nil {
		render.Status(r, http.StatusNotFound)
		render.JSON(w, r, responses.ErrorResponse{Error: "{{.ModelName}} not found"})
		return
	}

	if err := json.NewDecoder(r.Body).Decode(&record); err != nil {
		render.Status(r, http.StatusBadRequest)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := record.Validate(); err != nil {
		render.Status(r, http.StatusBadRequest)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}

	if err := c.DB.Save(&record).Error; err != nil {
		render.Status(r, http.StatusInternalServerError)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}
	render.JSON(w, r, record)
}

// Delete{{.ModelName}} deletes a {{.ModelName}} record.
// @Summary Delete a {{.ModelName}}
func (c *{{.ModelName}}Controller) Delete{{.ModelName}}(w http.ResponseWriter, r *http.Request) {
	var record models.{{.ModelName}}
	id := chi.URLParam(r, "id")

	if id == "" {
		render.Status(r, http.StatusBadRequest)
		render.JSON(w, r, responses.ErrorResponse{Error: "ID parameter is required"})
		return
	}

	if err := c.DB.First(&record, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			render.Status(r, http.StatusNotFound)
			render.JSON(w, r, responses.ErrorResponse{Error: "{{.ModelName}} not found"})
		} else {
			render.Status(r, http.StatusInternalServerError)
			render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		}
		return
	}

	if err := c.DB.Delete(&record).Error; err != nil {
		render.Status(r, http.StatusInternalServerError)
		render.JSON(w, r, responses.ErrorResponse{Error: err.Error()})
		return
	}
	render.JSON(w, r, map[string]string{"message": "{{.ModelName}} deleted"})
}
