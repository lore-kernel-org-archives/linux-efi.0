From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: efivarfs and writev() support
Date: Wed, 11 Mar 2015 08:12:52 -0700
Message-ID: <7F5112DD-6998-47D3-B6B9-5618E14E022A@holtmann.org>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org> <20150311134226.GB24174@codeblueprint.co.uk>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150311134226.GB24174-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

>> it seems that efivarfs only supports readv(), but when it comes to
>> writev(), I am getting an error. Is there any reason to not support
>> vectored write on this filesystem? Especially with the uint32 header
>> for each file, I think it would make perfect sense to support it.
> 
> What error are you seeing? I thought that the vfs fell back to a looped
> write if the file system doesn't support .write_iter()?

that seems to work for readv(), but not for writev().

> But yes, we definitely should support writev().

I just get an EIO error and have not traced this down any further.

Regards

Marcel
