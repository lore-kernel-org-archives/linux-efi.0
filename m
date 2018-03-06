From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 0/9] KEYS: Blacklisting & UEFI database load
Date: Tue, 6 Mar 2018 15:05:50 +0100
Message-ID: <6eabbb43-295e-9ba0-c0d9-120f48aa0e1d@suse.cz>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 11/16/2016, 07:10 PM, David Howells wrote:
> Here are two sets of patches.  Firstly, the first three patches provide a
> blacklist, making the following changes:
...
> Secondly, the remaining patches allow the UEFI database to be used to load
> the system keyrings:
...
> Dave Howells (2):
>       efi: Add EFI signature data types
>       efi: Add an EFI signature blob parser
> 
> David Howells (5):
>       KEYS: Add a system blacklist keyring
>       X.509: Allow X.509 certs to be blacklisted
>       PKCS#7: Handle blacklisted certificates
>       KEYS: Allow unrestricted boot-time addition of keys to secondary keyring
>       efi: Add SHIM and image security database GUID definitions
> 
> Josh Boyer (2):
>       MODSIGN: Import certificates from UEFI Secure Boot
>       MODSIGN: Allow the "db" UEFI variable to be suppressed

Hi,

what's the status of this please? Distributors (I checked SUSE, RedHat
and Ubuntu) have to carry these patches and every of them have to
forward-port the patches to new kernels. So are you going to resend the
PR to have this merged?

thanks,
-- 
js
suse labs
