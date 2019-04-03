From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Thu, 04 Apr 2019 00:21:12 +1100
Message-ID: <87r2aj1ayf.fsf@concordia.ellerman.id.au>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

Hi Claudio,

Thanks for posting this.

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> This patch set is part of a series that implements secure boot on
> PowerNV systems.
>
> In order to verify the OS kernel on PowerNV, secure boot requires X.509
> certificates trusted by the platform, the secure boot modes, and several
> other pieces of information. These are stored in secure variables
> controlled by OPAL, also known as OPAL secure variables.
>
> This patch set adds the following features:
>
> 1. Enable efivarfs by selecting CONFIG_EFI in the CONFIG_OPAL_SECVAR
>    introduced in this patch set. With CONFIG_EFIVAR_FS, userspace tools can
>    be used to manage the secure variables.
> 2. Add support for OPAL secure variables by overwriting the EFI hooks
>    (get_variable, get_next_variable, set_variable and query_variable_info)
>    with OPAL call wrappers. There is probably a better way to add this
>    support, for example, we are investigating if we could register the
>    efivar_operations rather than overwriting the EFI hooks. In this patch
>    set, CONFIG_OPAL_SECVAR selects CONFIG_EFI. If, instead, we registered
>    efivar_operations, CONFIG_EFIVAR_FS would need to depend on
>    CONFIG_EFI|| CONFIG_OPAL_SECVAR. Comments or suggestions on the
>    preferred technique would be greatly appreciated.

I am *very* reluctant to start selecting CONFIG_EFI on powerpc.

Simply because we don't actually have EFI, and I worry we're going to
both break assumptions in the EFI code as well as impose requirements on
the powerpc code that aren't really necessary.

So I'd definitely prefer we go the route of enabling efivarfs with an
alternate backend.

Better still would be a generic secure variable interface as Matt
suggests, if the userspace tools can be relatively easily adapted to use
that interface.

cheers
