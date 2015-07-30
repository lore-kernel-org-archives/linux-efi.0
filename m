From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 15:05:42 +0100
Message-ID: <20150730140542.GI2725@codeblueprint.co.uk>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
 <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
 <20150730110959.GJ15651@linux-rxt1.site>
 <20150730111819.GK15651@linux-rxt1.site>
 <20150730120916.GD2725@codeblueprint.co.uk>
 <20150730123116.GL15651@linux-rxt1.site>
 <20150730131723.GG2725@codeblueprint.co.uk>
 <20150730133947.GN15651@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730133947.GN15651@linux-rxt1.site>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jul, at 09:39:47PM, joeyli wrote:
> 
> OK, understood! Thanks for your suggestion!
> 
> But, I have a question about mapping Boot Code/Data to -4G area. I understand
> we need Runtime regions, and 1:1 mapping is the workaround of some buggy BIOS.
> But why should kernel mapping Boot regions to -4G area?

We map the Boot Service regions in the -4G area for simplicity, i.e.
it's easier to iterate through the EFI memory map in order, and map
things starting at -4G and working down to lower addresses, than it
would be to make different mapping decisions based on the region type.

As for why we map the Boot Service regions *at all*, that's also a bug
workaround, see commit 916f676f8dc0 ("x86, efi: Retain boot service code
until after switching to virtual mode"). We setup the mappings before we
call efi_free_boot_services().

-- 
Matt Fleming, Intel Open Source Technology Center
