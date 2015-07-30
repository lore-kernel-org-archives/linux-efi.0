From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 14:17:23 +0100
Message-ID: <20150730131723.GG2725@codeblueprint.co.uk>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
 <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
 <20150730110959.GJ15651@linux-rxt1.site>
 <20150730111819.GK15651@linux-rxt1.site>
 <20150730120916.GD2725@codeblueprint.co.uk>
 <20150730123116.GL15651@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730123116.GL15651@linux-rxt1.site>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jul, at 08:31:16PM, joeyli wrote:
> 
> I think hibernate overwrite it.

We absolutely must get a more detailed answer before going any further.

Simply put, if we're remapping the EFI regions into the virtual address
space and calling SetVirtualAddressMap() on hibernate resume there is no
reason that anyone should be using the old mappings.

And since you've demonstrated that we *are* using the old mappings,
we've likely got a bug somewhere that we need to get a handle on before
we paper over the issue.

Where exactly is the old mapping address being used? Is it that
efi.systab->runtime->get_variable is incorrect? If you could paste the
disassembled output where the page fault occurs, that would be helpful.

-- 
Matt Fleming, Intel Open Source Technology Center
