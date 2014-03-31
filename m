From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 09/12] uswsusp: Disable when trusted_kernel is true
Date: Mon, 31 Mar 2014 16:49:35 +0200
Message-ID: <20140331144935.GB21805@xo-6d-61-c0.localdomain>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
 <1393445473-15068-10-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1393445473-15068-10-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed 2014-02-26 15:11:10, Matthew Garrett wrote:
> uswsusp allows a user process to dump and then restore kernel state, which
> makes it possible to modify the running kernel. Disable this if
>  trusted_kernel is true.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

It can also enter S3 etc...

And dumping the kernel state should not be a problem, right? Only restoring is....

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
