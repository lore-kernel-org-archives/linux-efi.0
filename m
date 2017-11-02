From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked down
Date: Thu, 02 Nov 2017 21:30:11 +0000
Message-ID: <12321.1509658211@warthog.procyon.org.uk>
References: <1509650031.3507.20.camel@linux.vnet.ibm.com> <1509130095.3716.13.camel@linux.vnet.ibm.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk> <20240.1509643356@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509650031.3507.20.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> By this point, IMA-appraisal has already verified the kernel module
> signature back in kernel_read_file_from_fd(), if it was required.
>  Having a key with which to verify the appended signature or requiring
> an appended signature, should not be required as well.

I guess I don't need to put in any support for IMA here, then, and you've
taken care of it in your patchset such that it won't actually go into
module_sig_check() in that case (or will at least return immediately).

David
