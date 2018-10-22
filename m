From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 1/2] x86/efi: Unmap efi boot services code/data regions
 from efi_pgd
Date: Mon, 22 Oct 2018 07:12:25 -0700
Message-ID: <f88841ec-e104-fa8b-0be6-7418c7bf5161@intel.com>
References: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1540172145-17134-2-git-send-email-sai.praneeth.prakhya@intel.com>
 <20181022015738.GB24095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181022015738.GB24095@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

On 10/21/2018 06:57 PM, Ingo Molnar wrote:
> Does the CPU _ever_ look look at the PFN if the page is !_PAGE_PRESENT, 
> for example speculatively? If yes then what is the recommended value for 
> the pfn - zero perhaps?

I'll never say never. :)

For L1TF[1], we know the CPU did exactly this; it ignored the
_PAGE_PRESENT bit when fetching data from the L1.  That's what is worked
around with the gunk in arch/x86/include/asm/pgtable-invert.h.

I think Andi plugged the code in here at a low enough level in the page
table manipulation that pageattr.c should inherit it without doing
anything explicit.  But, Sai, you might want to double-check this.

1.
https://www.intel.com/content/www/us/en/architecture-and-technology/l1tf.html
