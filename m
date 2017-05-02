From: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] efi/efi_test: drop useless kfree
Date: Tue, 2 May 2017 22:48:35 +0800
Message-ID: <20170502144835.3jpwrdw6shnfr5g2@ThinkPad>
References: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
 <427b03b5f10b41014818b9e78f79da9581b213df.1493383416.git.geliangtang@gmail.com>
 <a8b99581-70e3-bf9a-bf62-4b13a8cc292c@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a8b99581-70e3-bf9a-bf62-4b13a8cc292c-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, May 02, 2017 at 03:11:45PM +0800, ivanhu wrote:
> 
> 
> On 04/29/2017 09:42 AM, Geliang Tang wrote:
> > Drop useless kfree when memdup_user() failed, since we have already
> > called kfree in memdup_user().
> > 
> > Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >   drivers/firmware/efi/test/efi_test.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
> > index 08129b7..00332ae 100644
> > --- a/drivers/firmware/efi/test/efi_test.c
> > +++ b/drivers/firmware/efi/test/efi_test.c
> > @@ -261,10 +261,8 @@ static long efi_runtime_set_variable(unsigned long arg)
> >   	}
> >   	data = memdup_user(setvariable.data, setvariable.data_size);
> > -	if (IS_ERR(data)) {
> > -		kfree(name);
> You mean "name" or "data"?
> 

Sorry, it's my mistake. The original code is correct. Please ignore this
patch.

-Geliang

> Cheers,
> Ivan
> 
> > +	if (IS_ERR(data))
> >   		return PTR_ERR(data);
> > -	}
> >   	status = efi.set_variable(name, &vendor_guid,
> >   				setvariable.attributes,
