package config

import (
	"path/filepath"
	"runtime"

	"github.com/hadenlabs/terraform-aws-ec2-instance/internal/errors"
	"github.com/hadenlabs/terraform-aws-ec2-instance/internal/version"
)

// Config struct field.
type Config struct {
	App App
}

// ReadConfig read values and files for config.
func (c *Config) ReadConfig() (*Config, error) {
	_, filePath, _, _ := runtime.Caller(0)
	rootDir := filepath.Dir(filePath)
	c.App.RootPath = filepath.Join(rootDir, "..")
	tag := version.Short()
	c.App.Version = tag
	return c, nil
}

// Initialize new instance.
func Initialize() *Config {
	conf := New()
	conf, err := conf.ReadConfig()
	if err != nil {
		panic(errors.Wrap(err, errors.ErrorReadConfig, ""))
	}
	return conf
}

// New create config.
func New() *Config {
	return &Config{}
}
