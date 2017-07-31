From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part1 PATCH v3 10/17] resource: Provide resource struct in
 resource walk callback
Date: Mon, 31 Jul 2017 10:26:31 +0200
Message-ID: <20170731082631.GA8672@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-11-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-11-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:50PM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In prep for a new function that will need additional resource information
> during the resource walk, update the resource walk callback to pass the
> resource structure.  Since the current callback start and end arguments
> are pulled from the resource structure, the callback functions can obtain
> them from the resource structure directly.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/powerpc/kernel/machine_kexec_file_64.c | 12 +++++++++---
>  arch/x86/kernel/crash.c                     | 18 +++++++++---------
>  arch/x86/kernel/pmem.c                      |  2 +-
>  include/linux/ioport.h                      |  4 ++--
>  include/linux/kexec.h                       |  2 +-
>  kernel/kexec_file.c                         |  5 +++--
>  kernel/resource.c                           |  9 +++++----
>  7 files changed, 30 insertions(+), 22 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
