From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 6/6] Documentation/x86: Update EFI memory region
 description
Date: Thu, 12 Nov 2015 19:37:05 +0100
Message-ID: <20151112183704.GE3838@pd.tnic>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@codemonkey.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 12, 2015 at 03:40:23PM +0000, Matt Fleming wrote:
> Make it clear that the EFI page tables are only available during EFI
> runtime calls since that subject has come up a fair numbers of times
> in the past.
> 
> Additionally, add the EFI region start and end addresses to the table
> so that it's possible to see at a glance where they fall in relation
> to other regions.
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Dave Jones <davej@codemonkey.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Denys Vlasenko <dvlasenk@redhat.com>,
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  Documentation/x86/x86_64/mm.txt | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
