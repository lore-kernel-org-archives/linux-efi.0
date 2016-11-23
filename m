From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 23 Nov 2016 11:25:57 +0000
Message-ID: <18007.1479900357@warthog.procyon.org.uk>
References: <20161123104757.GE24624@leverpostej> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk> <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161123104757.GE24624@leverpostej>
Content-ID: <18006.1479900357.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: dhowells@redhat.com, lukas@wunner.de, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Mark Rutland <mark.rutland@arm.com> wrote:

> 	int secure_boot = efi_get_secureboot(sys_table);
> 
> 	if (secure_boot > 0)
> 		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
> 	if (secure_boot < 0)
> 		pr_efi_err(sys_table,
> 			"could not determine UEFI Secure Boot status.\n");

In which case, should this be moved into efi_get_secureboot() and it return a
bool?

David
