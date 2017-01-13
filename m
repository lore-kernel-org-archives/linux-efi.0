From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Fri, 13 Jan 2017 16:10:23 +0800
Message-ID: <20170113081015.GA5328@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.860924858@redhat.com>
 <CAKv+Gu-cdhvAM2Vkqv8uokZAqD3k0kLbGu1UYwgQOYj5Es0g=g@mail.gmail.com>
 <20170112211953.GA2709@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112211953.GA2709@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

On 01/13/17 at 05:20am, Dave Young wrote:
> On 01/12/17 at 04:15pm, Ard Biesheuvel wrote:
> > Hello Dave,
> > 
> > On 12 January 2017 at 09:41, Dave Young <dyoung@redhat.com> wrote:
> > > There are memory ranges like below when I testing early efi_mem_reserve:
> > >
> > > efi: mem62: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> > > efi: mem63: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> > > efi: mem64: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> > > efi: mem65: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> > > efi: mem66: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> > > efi: mem67: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> > >
> > 
> > Did you spot Peter's patch to prune invalid memmap entries?
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/efi/efi.git/commit/?h=next&id=b2a91a35445229
> > 
> > I would expect this patch to no longer be necessary with that in place, no?
> 
> Ard, good suggestion, I did not notice that patch, will try. Actually
> I'm not sure about fake_mem handling, if we can filter out the invalid
> ranges then it will be natural to drop this one after a test.

The commit works for me. I updated the series.

I addressed comments known, moved patch 1 to 4/4 with only boot service
(dropped loader areas checking), I plan to send them out next Monday
see if there are more comments. 

If anyone who want to try them now, feel free to download from below url:
http://people.redhat.com/~ruyang/efi-bgrt/

Thanks
Dave
