From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 6/6] Documentation/x86: Update EFI memory region
 description
Date: Thu, 19 Nov 2015 11:22:24 +0000
Message-ID: <20151119112224.GA2577@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
 <20151113092210.GB19922@gmail.com>
 <20151113092906.GD2716@codeblueprint.co.uk>
 <20151118081859.GB23844@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151118081859.GB23844@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@codemonkey.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Nov, at 09:18:59AM, Ingo Molnar wrote:
> 
> Ah yes - but then the text is misleading, what does 'in the virtual range of 64Gb' 
> mean? A virtual memory range is a specific range of addresses - like in the table 
> you extended.
> 
> A better phrasing would be something like:
> 
>  We map EFI runtime services in the 'efi_pgd' PGD in a 64Gb large virtual memory
>  window (this size is arbitrary, it can be raised later if needed).
> 
> Agreed?

Sounds OK to me.
