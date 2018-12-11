From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2 5/7] efi: Import certificates from UEFI Secure Boot
Date: Wed, 12 Dec 2018 05:47:58 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1812120547110.11653@namei.org>
References: <20181208202705.18673-1-nayna@linux.ibm.com> <20181208202705.18673-6-nayna@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181208202705.18673-6-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 9 Dec 2018, Nayna Jain wrote:

> +/*
> + * Blacklist an X509 TBS hash.
> + */
> +static __init void uefi_blacklist_x509_tbs(const char *source,
> +					   const void *data, size_t len)
> +{
> +	char *hash, *p;
> +
> +	hash = kmalloc(4 + len * 2 + 1, GFP_KERNEL);
> +	if (!hash)
> +		return;
> +	p = memcpy(hash, "tbs:", 4);
> +	p += 4;
> +	bin2hex(p, data, len);
> +	p += len * 2;
> +	*p = 0;
> +
> +	mark_hash_blacklisted(hash);
> +	kfree(hash);
> +}
> +
> +/*
> + * Blacklist the hash of an executable.
> + */
> +static __init void uefi_blacklist_binary(const char *source,
> +					 const void *data, size_t len)
> +{
> +	char *hash, *p;
> +
> +	hash = kmalloc(4 + len * 2 + 1, GFP_KERNEL);
> +	if (!hash)
> +		return;
> +	p = memcpy(hash, "bin:", 4);
> +	p += 4;
> +	bin2hex(p, data, len);
> +	p += len * 2;
> +	*p = 0;
> +
> +	mark_hash_blacklisted(hash);
> +	kfree(hash);
> +}
> 

These could be refactored into one function.


-- 
James Morris
<jmorris@namei.org>
