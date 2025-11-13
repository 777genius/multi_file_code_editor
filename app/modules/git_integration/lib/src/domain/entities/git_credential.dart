import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart' as fp;

part 'git_credential.freezed.dart';

/// Git credential entity
///
/// Represents authentication credentials for git remote operations.
/// Supports multiple authentication methods:
/// - Username/Password (HTTPS)
/// - Personal Access Token (GitHub, GitLab, etc.)
/// - SSH Key (public/private key pair)
/// - OAuth Token (OAuth 2.0 flow)
@freezed
class GitCredential with _$GitCredential {
  const GitCredential._();

  const factory GitCredential({
    /// Remote URL this credential is for
    required String url,

    /// Username for authentication
    required String username,

    /// Password (for HTTPS basic auth)
    fp.Option<String>? password,

    /// Personal access token (preferred over password)
    fp.Option<String>? token,

    /// OAuth access token
    fp.Option<String>? oauthToken,

    /// OAuth refresh token
    fp.Option<String>? refreshToken,

    /// SSH private key content
    fp.Option<String>? sshPrivateKey,

    /// SSH public key content
    fp.Option<String>? sshPublicKey,

    /// SSH key passphrase
    fp.Option<String>? sshPassphrase,

    /// Credential type
    required GitCredentialType type,

    /// Provider (github, gitlab, bitbucket, etc.)
    fp.Option<String>? provider,

    /// Expiration date (for tokens)
    fp.Option<DateTime>? expiresAt,

    /// Creation date
    required DateTime createdAt,

    /// Last used date
    fp.Option<DateTime>? lastUsedAt,
  }) = _GitCredential;

  /// Create credential with username/password
  factory GitCredential.password({
    required String url,
    required String username,
    required String password,
  }) {
    return GitCredential(
      url: url,
      username: username,
      password: fp.some(password),
      token: fp.none(),
      oauthToken: fp.none(),
      refreshToken: fp.none(),
      sshPrivateKey: fp.none(),
      sshPublicKey: fp.none(),
      sshPassphrase: fp.none(),
      type: GitCredentialType.password,
      provider: fp.none(),
      expiresAt: fp.none(),
      createdAt: DateTime.now(),
      lastUsedAt: fp.none(),
    );
  }

  /// Create credential with personal access token
  factory GitCredential.token({
    required String url,
    required String username,
    required String token,
    String? provider,
    DateTime? expiresAt,
  }) {
    return GitCredential(
      url: url,
      username: username,
      password: fp.none(),
      token: fp.some(token),
      oauthToken: fp.none(),
      refreshToken: fp.none(),
      sshPrivateKey: fp.none(),
      sshPublicKey: fp.none(),
      sshPassphrase: fp.none(),
      type: GitCredentialType.token,
      provider: provider != null ? fp.some(provider) : fp.none(),
      expiresAt: expiresAt != null ? fp.some(expiresAt) : fp.none(),
      createdAt: DateTime.now(),
      lastUsedAt: fp.none(),
    );
  }

  /// Create credential with OAuth token
  factory GitCredential.oauth({
    required String url,
    required String username,
    required String accessToken,
    String? refreshToken,
    required String provider,
    DateTime? expiresAt,
  }) {
    return GitCredential(
      url: url,
      username: username,
      password: fp.none(),
      token: fp.none(),
      oauthToken: fp.some(accessToken),
      refreshToken:
          refreshToken != null ? fp.some(refreshToken) : fp.none(),
      sshPrivateKey: fp.none(),
      sshPublicKey: fp.none(),
      sshPassphrase: fp.none(),
      type: GitCredentialType.oauth,
      provider: fp.some(provider),
      expiresAt: expiresAt != null ? fp.some(expiresAt) : fp.none(),
      createdAt: DateTime.now(),
      lastUsedAt: fp.none(),
    );
  }

  /// Create credential with SSH key
  factory GitCredential.ssh({
    required String url,
    required String username,
    required String privateKey,
    required String publicKey,
    String? passphrase,
  }) {
    return GitCredential(
      url: url,
      username: username,
      password: fp.none(),
      token: fp.none(),
      oauthToken: fp.none(),
      refreshToken: fp.none(),
      sshPrivateKey: fp.some(privateKey),
      sshPublicKey: fp.some(publicKey),
      sshPassphrase:
          passphrase != null ? fp.some(passphrase) : fp.none(),
      type: GitCredentialType.ssh,
      provider: fp.none(),
      expiresAt: fp.none(),
      createdAt: DateTime.now(),
      lastUsedAt: fp.none(),
    );
  }

  /// Check if credential is expired
  bool get isExpired {
    return (expiresAt ?? fp.none()).fold(
      () => false,
      (expires) => DateTime.now().isAfter(expires),
    );
  }

  /// Check if credential is about to expire (within 7 days)
  bool get isExpiringSoon {
    return (expiresAt ?? fp.none()).fold(
      () => false,
      (expires) {
        final daysUntilExpiration = expires.difference(DateTime.now()).inDays;
        return daysUntilExpiration <= 7 && daysUntilExpiration > 0;
      },
    );
  }

  /// Get credential value for git authentication
  String? get credentialValue {
    switch (type) {
      case GitCredentialType.password:
        return (password ?? fp.none()).toNullable();
      case GitCredentialType.token:
        return (token ?? fp.none()).toNullable();
      case GitCredentialType.oauth:
        return (oauthToken ?? fp.none()).toNullable();
      case GitCredentialType.ssh:
        return (sshPrivateKey ?? fp.none()).toNullable();
    }
  }

  /// Get masked credential value for display (hides sensitive data)
  String get maskedValue {
    final value = credentialValue;
    if (value == null || value.isEmpty) return '(empty)';

    if (value.length <= 8) {
      return '********';
    }

    // Show first 4 and last 4 characters
    return '${value.substring(0, 4)}...${value.substring(value.length - 4)}';
  }

  /// Update last used timestamp
  GitCredential markAsUsed() {
    return copyWith(lastUsedAt: fp.some(DateTime.now()));
  }

  /// Check if credential can be used for URL
  bool canAuthenticateUrl(String targetUrl) {
    // Exact match
    if (url == targetUrl) return true;

    // Check if URLs are from same domain
    try {
      final credentialUri = Uri.parse(url);
      final targetUri = Uri.parse(targetUrl);

      // Same host and scheme
      return credentialUri.host == targetUri.host &&
          credentialUri.scheme == targetUri.scheme;
    } catch (e) {
      return false;
    }
  }

  /// Get provider-specific scopes (for OAuth)
  List<String> get defaultScopes {
    final providerName = (provider ?? fp.none()).toNullable();
    if (providerName == null) return [];

    switch (providerName.toLowerCase()) {
      case 'github':
        return ['repo', 'user', 'gist'];
      case 'gitlab':
        return ['api', 'read_user', 'read_repository', 'write_repository'];
      case 'bitbucket':
        return ['repository', 'repository:write', 'account'];
      default:
        return [];
    }
  }

  /// Convert to git credential helper format
  String toGitCredentialFormat() {
    final buffer = StringBuffer();
    buffer.writeln('protocol=${Uri.parse(url).scheme}');
    buffer.writeln('host=${Uri.parse(url).host}');
    buffer.writeln('username=$username');

    final cred = credentialValue;
    if (cred != null) {
      buffer.writeln('password=$cred');
    }

    return buffer.toString();
  }
}

/// Git credential type
enum GitCredentialType {
  /// Username and password (HTTPS)
  password,

  /// Personal access token
  token,

  /// OAuth token
  oauth,

  /// SSH key pair
  ssh,
}

/// Extension for GitCredentialType
extension GitCredentialTypeX on GitCredentialType {
  String get displayName {
    switch (this) {
      case GitCredentialType.password:
        return 'Password';
      case GitCredentialType.token:
        return 'Access Token';
      case GitCredentialType.oauth:
        return 'OAuth';
      case GitCredentialType.ssh:
        return 'SSH Key';
    }
  }

  String get description {
    switch (this) {
      case GitCredentialType.password:
        return 'Username and password authentication';
      case GitCredentialType.token:
        return 'Personal access token (recommended)';
      case GitCredentialType.oauth:
        return 'OAuth 2.0 authentication';
      case GitCredentialType.ssh:
        return 'SSH public/private key pair';
    }
  }

  bool get isSecure {
    // Password is least secure, others are more secure
    return this != GitCredentialType.password;
  }
}
