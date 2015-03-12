From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: efivarfs and writev() support
Date: Thu, 12 Mar 2015 07:58:35 -0700
Message-ID: <BC49553F-B4CE-4ED5-A1CE-D180E200AA60@holtmann.org>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org> <20150311134226.GB24174@codeblueprint.co.uk> <7F5112DD-6998-47D3-B6B9-5618E14E022A@holtmann.org> <20150312063437.GK29656@ZenIV.linux.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150312063437.GK29656@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

Hi Al,

>>>> it seems that efivarfs only supports readv(), but when it comes to
>>>> writev(), I am getting an error. Is there any reason to not support
>>>> vectored write on this filesystem? Especially with the uint32 header
>>>> for each file, I think it would make perfect sense to support it.
>>> 
>>> What error are you seeing? I thought that the vfs fell back to a looped
>>> write if the file system doesn't support .write_iter()?
>> 
>> that seems to work for readv(), but not for writev().
>> 
>>> But yes, we definitely should support writev().
>> 
>> I just get an EIO error and have not traced this down any further.
> 
> What arguments are you feeding to it?  Note that the thing is sensitive to
> range boundaries; it's not as if series of write() to it would be equivalent
> to single write() from concatenation.  And writev() is equivalent to
> series of write().

I did something really simple and from my point obvious. I took the uint32 header that every file needs and put that in iov[0] pointer and then the rest in iov[1] pointer. The reason was that I didn't want to copy the actual file content around to just add a uint32 header in front of it.

> If you want behaviour a-la UDP sockets (syscall boundaries matter,
> boundaries between vector elements do not), we can certainly do that,
> but this is different from the current semantics.  AFAICS, said
> semantics makes little sense, but it's a user-visible change...

I do not know about the specific semantics of efivarfs and frankly I have not tried every single combination. However it sounds to me that currently it requires that the whole file content is provided with a single write(). I have no idea if this is true or not. I do not know enough about the internals here.

Maybe efivarfs just needs to implemented .write_iter properly to actually support writev() and can not rely on a fallback of multiple write() calls.

Regards

Marcel
