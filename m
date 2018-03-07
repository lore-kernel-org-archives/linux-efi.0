From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] KEYS: Blacklisting & UEFI database load
Date: Wed, 07 Mar 2018 08:18:02 -0500
Message-ID: <1520428682.10396.445.camel@linux.vnet.ibm.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
         <6eabbb43-295e-9ba0-c0d9-120f48aa0e1d@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6eabbb43-295e-9ba0-c0d9-120f48aa0e1d@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-03-06 at 15:05 +0100, Jiri Slaby wrote:
> On 11/16/2016, 07:10 PM, David Howells wrote:
> > Here are two sets of patches.  Firstly, the first three patches provide a
> > blacklist, making the following changes:
> ...
> > Secondly, the remaining patches allow the UEFI database to be used to load
> > the system keyrings:
> ...
> > Dave Howells (2):
> >       efi: Add EFI signature data types
> >       efi: Add an EFI signature blob parser
> > 
> > David Howells (5):
> >       KEYS: Add a system blacklist keyring
> >       X.509: Allow X.509 certs to be blacklisted
> >       PKCS#7: Handle blacklisted certificates
> >       KEYS: Allow unrestricted boot-time addition of keys to secondary keyring
> >       efi: Add SHIM and image security database GUID definitions
> > 
> > Josh Boyer (2):
> >       MODSIGN: Import certificates from UEFI Secure Boot
> >       MODSIGN: Allow the "db" UEFI variable to be suppressed
> 
> Hi,
> 
> what's the status of this please? Distributors (I checked SUSE, RedHat
> and Ubuntu) have to carry these patches and every of them have to
> forward-port the patches to new kernels. So are you going to resend the
> PR to have this merged?

With secure boot enabled, we establish a signature chain of trust,
rooted in HW, up to the kernel and then transition from those keys to
a new set of keys builtin the kernel and loaded onto the
builtin_trusted_keys (builtin).

Enabling the secondary_builtin_keys (secondary) allows keys signed by
a key on the builtin keyring to be added to the secondary keyring.
 Any key, signed by a key on either the builtin or secondary keyring,
can be added to the IMA trusted keyring.

The "KEYS: Allow unrestricted boot-time addition of keys to secondary
keyring" patch loads the platform keys directly onto the secondary
keyring, without requiring them to be signed by a key on the builtin
or secondary keyring.  With this change, any key signed by a platfrom
key on the secondary, can be loaded onto the .ima trusted keyring.

Just because I trust the platform keys prior to booting the kernel,
doesn't mean that I *want* to trust those keys once booted.  There
are, however, places where we need access to those keys to verify a
signature (eg. kexec kernel image).

Nayna Jain's "certs: define a trusted platform keyring" patch set
introduces a new, separate keyring for these platform keys.

Mimi
