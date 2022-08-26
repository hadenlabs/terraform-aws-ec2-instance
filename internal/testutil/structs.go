package testutil

// Server is the kind of error.
type Server string

// Servers Types.
const (
	Company     Server = "evilcorp"
	Environment Server = "testing"
	Stage       Server = "test"
	PublicKey   Server = "/test/fixtures/keys/instance-test.pub"
	PrivateKey  Server = "/test/fixtures/keys/instance-test.pem"
)
