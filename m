From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Wed, 19 Aug 2015 17:31:45 +0100
Message-ID: <20150819163145.GI3233@codeblueprint.co.uk>
References: <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
 <20150730110959.GJ15651@linux-rxt1.site>
 <20150730111819.GK15651@linux-rxt1.site>
 <20150730120916.GD2725@codeblueprint.co.uk>
 <20150730123116.GL15651@linux-rxt1.site>
 <20150730131723.GG2725@codeblueprint.co.uk>
 <20150730133947.GN15651@linux-rxt1.site>
 <20150730140542.GI2725@codeblueprint.co.uk>
 <20150730141601.GO15651@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730141601.GO15651@linux-rxt1.site>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jul, at 10:16:01PM, joeyli wrote:
> 
> Thanks for your explanation.
> 
> For my issue, I will check if rewriting the VA of runtime services can fix issue.
> If not, then I think need find a way to sync the mapping in EFI page table between
> boot kernel and image kernel.

Hey Joey, did you make any progress with this issue?

-- 
Matt Fleming, Intel Open Source Technology Center
