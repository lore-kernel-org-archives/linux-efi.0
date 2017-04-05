From: Dave Young <dyoung@redhat.com>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Wed, 5 Apr 2017 09:23:41 +0800
Message-ID: <20170405012341.GA3465@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
 <20170316124132.GF6261@codeblueprint.co.uk>
 <20170317020951.GA3942@dhcp-128-65.nay.redhat.com>
 <20170317133232.GI6261@codeblueprint.co.uk>
 <20170320021412.GA3793@dhcp-128-65.nay.redhat.com>
 <20170404133719.GE19827@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170404133719.GE19827@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Omar Sandoval <osandov@osandov.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, kernel-team@fb.com, kexec@lists.infradead.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 04/04/17 at 02:37pm, Matt Fleming wrote:
> On Mon, 20 Mar, at 10:14:12AM, Dave Young wrote:
> > 
> > Matt, I'm fine if you prefer to capture the range checking errors.
> > Would you like me to post it or just you send it out?
> 
> Can you please send out the patch with the minimal change to
> efi_arch_mem_reserve() and we'll get it into urgent ASAP.

Omar has sent it out, for the lookup function issue I think I can do it
after this one later.

Thanks
Dave
