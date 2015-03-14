From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: efivarfs and writev() support
Date: Sat, 14 Mar 2015 09:33:00 -0700
Message-ID: <C20D75CF-FA82-43E5-BF70-E4E30E1D987B@holtmann.org>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org> <20150311134226.GB24174@codeblueprint.co.uk> <7F5112DD-6998-47D3-B6B9-5618E14E022A@holtmann.org> <20150312063437.GK29656@ZenIV.linux.org.uk> <BC49553F-B4CE-4ED5-A1CE-D180E200AA60@holtmann.org> <20150312170344.GN29656@ZenIV.linux.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150312170344.GN29656-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Al,

>> I do not know about the specific semantics of efivarfs and frankly I have not tried every single combination. However it sounds to me that currently it requires that the whole file content is provided with a single write(). I have no idea if this is true or not. I do not know enough about the internals here.
>> 
>> Maybe efivarfs just needs to implemented .write_iter properly to actually support writev() and can not rely on a fallback of multiple write() calls.
> 
> Sigh...  There are three variants of write/writev semantics:
> 	1) stream.  Neither syscall nor vector member boundaries matter,
> the thing on the other end of IO channel might interpret the stream of
> data it's being fed and carve it into pieces, but that's a function of
> the contents.  TCP sockets are like that, so are pipes, etc.
> 	2) syscall-level datagram.  Vector member boundaries do not matter,
> syscall ones do.  UDP is like that - iovec is pure scatter-gather thing
> there; the boundaries come from syscalls.
> 	3) vector-level datagram.  Each vector member represents a single
> datagram, syscall boundaries do not matter.  I.e. iovec is an array of
> datagrams.  Most of character devices are like that.  And so's efivarfs.
> 
> What you are proposing seems to be switching it to syscall-level datagram
> behaviour.  It's very unlikely to break anything (I would be very surprised
> if anything tried to use "send this array of datagrams", simply because it's
> usually[1] bloody pointless for those files), but it *is* a user-visible API
> change.
> 
> And if we go for it, sure, we should just switch to ->write_iter() and be
> done with that - kmalloc(iov_iter_count(to), GFP_KERNEL), copy_from_iter(),
> use the first 4 bytes for attributes and the rest for body, same as we do
> now.

I say we should support writev() on efivarfs. Not supporting it seems odd especially since that is not documented anywhere. So yes, I am for adding .write_iter() support and be done with that.

Also please note that even write(,4) and write(,n) does not work either. You can not write partial entries as it seems. Maybe you are able to append, but it seems the initial creation of the variable has to be done with a single write() call. Anything else ends up in a file with 0 length.

Regards

Marcel
