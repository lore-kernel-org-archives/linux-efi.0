From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: efivarfs and writev() support
Date: Thu, 12 Mar 2015 06:34:37 +0000
Message-ID: <20150312063437.GK29656@ZenIV.linux.org.uk>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org>
 <20150311134226.GB24174@codeblueprint.co.uk>
 <7F5112DD-6998-47D3-B6B9-5618E14E022A@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7F5112DD-6998-47D3-B6B9-5618E14E022A-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 11, 2015 at 08:12:52AM -0700, Marcel Holtmann wrote:
> Hi Matt,
> 
> >> it seems that efivarfs only supports readv(), but when it comes to
> >> writev(), I am getting an error. Is there any reason to not support
> >> vectored write on this filesystem? Especially with the uint32 header
> >> for each file, I think it would make perfect sense to support it.
> > 
> > What error are you seeing? I thought that the vfs fell back to a looped
> > write if the file system doesn't support .write_iter()?
> 
> that seems to work for readv(), but not for writev().
> 
> > But yes, we definitely should support writev().
> 
> I just get an EIO error and have not traced this down any further.

What arguments are you feeding to it?  Note that the thing is sensitive to
range boundaries; it's not as if series of write() to it would be equivalent
to single write() from concatenation.  And writev() is equivalent to
series of write().

If you want behaviour a-la UDP sockets (syscall boundaries matter,
boundaries between vector elements do not), we can certainly do that,
but this is different from the current semantics.  AFAICS, said
semantics makes little sense, but it's a user-visible change...
