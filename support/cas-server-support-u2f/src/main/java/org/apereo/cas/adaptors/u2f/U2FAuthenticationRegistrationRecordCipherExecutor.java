package org.apereo.cas.adaptors.u2f;

import org.apereo.cas.util.cipher.BaseStringCipherExecutor;

import lombok.extern.slf4j.Slf4j;

/**
 * This is {@link U2FAuthenticationRegistrationRecordCipherExecutor}.
 *
 * @author Dmitriy Kopylenko
 * @since 5.3.0
 */
@Slf4j
public class U2FAuthenticationRegistrationRecordCipherExecutor extends BaseStringCipherExecutor {

    public U2FAuthenticationRegistrationRecordCipherExecutor(final String secretKeyEncryption,
                                                             final String secretKeySigning,
                                                             final String alg) {
        super(secretKeyEncryption, secretKeySigning, alg);
    }

    @Override
    public String getName() {
        return "U2F Authentication";
    }

    @Override
    protected String getEncryptionKeySetting() {
        return "cas.authn.mfa.u2f.crypto.encryption.key";
    }

    @Override
    protected String getSigningKeySetting() {
        return "cas.authn.mfa.u2f.crypto.signing.key";
    }
}
