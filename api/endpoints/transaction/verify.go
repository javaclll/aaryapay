package transaction

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type TransactionVerifyController struct{}

func (TransactionVerifyController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "transaction verify",
	})
}
