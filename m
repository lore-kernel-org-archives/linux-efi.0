From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Fri, 21 Oct 2016 16:20:45 -0700
Message-ID: <CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw@mail.gmail.com>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk> <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
 <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
 <20161021154129.GH27807@codeblueprint.co.uk> <20161021202022.GI27807@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021202022.GI27807-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 21, 2016 at 1:20 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 21 Oct, at 04:41:29PM, Matt Fleming wrote:
>>
>> FYI, I've been able to reproduce some crash when using your EFI memory
>> map layout under Qemu and forcing the ESRT driver to reserve the space.
>
> Nope, that was a bug in my hack. I can't get Qemu to crash while using
> your memory map layout.
>
> Any chance you can insert "while(1)" loops into the EFI boot paths for
> a kernel that is known to reboot or trigger a triple fault in kernels
> that hang, so that we can narrow in on the issue. See,
>
>   http://www.codeblueprint.co.uk/2015/04/early-x86-linux-boot-debug-tricks.html

I can take a look, but it will not be until Monday when I have
physical access to the system again.
