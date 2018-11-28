From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 5/7] efi: Import certificates from UEFI Secure Boot
Date: Wed, 28 Nov 2018 10:46:28 -0500
Message-ID: <1543419988.3902.216.camel@linux.ibm.com>
References: <20181125151500.8298-1-nayna@linux.ibm.com>
         <20181125151500.8298-6-nayna@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181125151500.8298-6-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.ibm.com>, Josh Boyer <jwboyer@fedoraproject.org>, linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au
List-Id: linux-efi@vger.kernel.org

On Sun, 2018-11-25 at 20:44 +0530, Nayna Jain wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
> 
> New Patch Description:
> ======================
> 
> Secure Boot stores a list of allowed certificates in the 'db' variable.
> This patch imports those certificates into the platform keyring. The shim
> UEFI bootloader has a similar certificate list stored in the 'MokListRT'
> variable. We import those as well.
> 
> Secure Boot also maintains a list of disallowed certificates in the 'dbx'
> variable. We load those certificates into the system blacklist keyring
> and forbid any kernel signed with those from loading.
> 
> Original Patch Description:
> ============================
> 
> Secure Boot stores a list of allowed certificates in the 'db' variable.
> This imports those certificates into the system trusted keyring.  This
> allows for a third party signing certificate to be used in conjunction
> with signed modules. By importing the public certificate into the 'db'
> variable, a user can allow a module signed with that certificate to
> load. The shim UEFI bootloader has a similar certificate list stored
> in the 'MokListRT' variable. We import those as well.
> 
> Secure Boot also maintains a list of disallowed certificates in the 'dbx'
> variable. We load those certificates into the newly introduced system
> blacklist keyring and forbid any module signed with those from loading and
> forbid the use within the kernel of any key with a matching hash.
> 
> This facility is enabled by setting CONFIG_LOAD_UEFI_KEYS.

There are quite a few checkpatch.pl warnings that need to be
addressed, including the missing SPDX license.

Mimi
