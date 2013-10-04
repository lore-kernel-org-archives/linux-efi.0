From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Remove redundant and incorrect memset()
Date: Fri, 4 Oct 2013 19:39:22 +0200
Message-ID: <20131004173922.GA15959@gmail.com>
References: <20131003131054.GB27835@gmail.com>
 <1380902566-30867-1-git-send-email-roy.franz@linaro.org>
 <20131004173310.GA15689@gmail.com>
 <CAFECyb_ddUU8p87iOZ43PxW3h-E5cJ-0BUEr9i4Z-VrUez6=Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb_ddUU8p87iOZ43PxW3h-E5cJ-0BUEr9i4Z-VrUez6=Jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, patches@linaro.org, msalter@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

* Roy Franz <roy.franz@linaro.org> wrote:

> On Oct 4, 2013 1:33 PM, "Ingo Molnar" <mingo@kernel.org> wrote:
> >
> >
> > * Roy Franz <roy.franz@linaro.org> wrote:
> >
> > > Remove a redundant memset() call from efi_relocate_kernel() that
> > > was clearing memory that would be used by BSS in non-compressed
> > > images loaded with this function.  This clear was redundant with
> > > the clearing done in the image itself, and also implemented incorrectly
> > > with a 0 length.
> > >
> > > Signed-off-by: Roy Franz <roy.franz@linaro.org>
> > > Acked-by: Mark Salter <msalter@redhat.com>
> >
> > Note the title:
> >
> >    [PATCH] Remove redundant and incorrect memset()
> >
> > if it's both redundant *and* incorrect then the other memset() must be
> > incorrect too and must be removed as well ;-)
> >
> > I suspect you wanted the title to say:
> >
> >    [PATCH] Remove redundant memset()
> >
> > ?
> >
> > Thanks,
> >
> >         Ingo
> Hi Ingo,
> 
>   The memset being removed is redundant  with a correctly implemented
> memset in the kernel itself.   The memset being removed is also incorrect,
> with a hard coded length of 0.

So it was redundantly clearing nothing? ;-)

Anyway, I agree, the title makes sense.

Thanks,

	Ingo
