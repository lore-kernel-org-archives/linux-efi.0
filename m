From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: efivarfs and writev() support
Date: Thu, 12 Mar 2015 17:03:44 +0000
Message-ID: <20150312170344.GN29656@ZenIV.linux.org.uk>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org>
 <20150311134226.GB24174@codeblueprint.co.uk>
 <7F5112DD-6998-47D3-B6B9-5618E14E022A@holtmann.org>
 <20150312063437.GK29656@ZenIV.linux.org.uk>
 <BC49553F-B4CE-4ED5-A1CE-D180E200AA60@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BC49553F-B4CE-4ED5-A1CE-D180E200AA60@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 12, 2015 at 07:58:35AM -0700, Marcel Holtmann wrote:

> I do not know about the specific semantics of efivarfs and frankly I have not tried every single combination. However it sounds to me that currently it requires that the whole file content is provided with a single write(). I have no idea if this is true or not. I do not know enough about the internals here.
> 
> Maybe efivarfs just needs to implemented .write_iter properly to actually support writev() and can not rely on a fallback of multiple write() calls.

Sigh...  There are three variants of write/writev semantics:
	1) stream.  Neither syscall nor vector member boundaries matter,
the thing on the other end of IO channel might interpret the stream of
data it's being fed and carve it into pieces, but that's a function of
the contents.  TCP sockets are like that, so are pipes, etc.
	2) syscall-level datagram.  Vector member boundaries do not matter,
syscall ones do.  UDP is like that - iovec is pure scatter-gather thing
there; the boundaries come from syscalls.
	3) vector-level datagram.  Each vector member represents a single
datagram, syscall boundaries do not matter.  I.e. iovec is an array of
datagrams.  Most of character devices are like that.  And so's efivarfs.

What you are proposing seems to be switching it to syscall-level datagram
behaviour.  It's very unlikely to break anything (I would be very surprised
if anything tried to use "send this array of datagrams", simply because it's
usually[1] bloody pointless for those files), but it *is* a user-visible API
change.

And if we go for it, sure, we should just switch to ->write_iter() and be
done with that - kmalloc(iov_iter_count(to), GFP_KERNEL), copy_from_iter(),
use the first 4 bytes for attributes and the rest for body, same as we do
now.

[1] not always - variable doesn't have to have "each time we set it, the
old value is completely lost" semantics, even though most of them are
that way.
