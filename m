From: Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Re: [PATCH 4.4 05/27] x86/efi: Build our own page table structures
Date: Thu, 07 Dec 2017 22:43:49 +0000
Message-ID: <1512686629.18523.217.camel@codethink.co.uk>
References: <20171204155942.271814507@linuxfoundation.org>
         <20171204155942.482436478@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171204155942.482436478@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Dave Jones <davej@codemonkey.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Stephen Smalley <sds@tycho.nsa.gov>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Ghannam, Yaz
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-12-04 at 16:59 +0100, Greg Kroah-Hartman wrote:
> 4.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Matt Fleming <matt@codeblueprint.co.uk>
> 
> commit 67a9108ed4313b85a9c53406d80dc1ae3f8c3e36 upstream.
[...]

It looks like this will cause regressions unless you also apply:

21cdb6b56843 x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs
b61a76f8850d x86/efi: Map RAM into the identity page table for mixed mode
753b11ef8e92 x86/efi: Setup separate EFI page tables in kexec paths

and possibly also:

08914f436bdd x86/platform/UV: Bring back the call to map_low_mmrs in uv_system_init
683ad8092cd2 x86/efi: Fix 7-parameter efi_call()s
80e75596079f efi: Convert efi_call_virt() to efi_call_virt_pointer()
d1be84a232e3 x86/uv: Update uv_bios_call() to use efi_call_virt_pointer()

Ben.

-- 
Ben Hutchings
Software Developer, Codethink Ltd.
