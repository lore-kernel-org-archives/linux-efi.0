From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Enable user helper interface for efi capsule
 update
Date: Tue, 4 Nov 2014 14:07:51 +0000
Message-ID: <1415110071.26277.28.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <5457D883.4050201@amacapital.net> <20141103212706.GE7379@kroah.com>
	 <CALCETrUNCuFvwkzbU4dWB0GH4mJKKV1e6jCNrSLVJe+n_et3kQ@mail.gmail.com>
	 <20141103230234.GA9427@kroah.com>
	 <CALCETrUtxqLaziC_f6iTEgKNhmTgJR6bOLJ=e=O22X_RsBc9sw@mail.gmail.com>
	 <20141104003849.GA15147@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141104003849.GA15147-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-11-03 at 16:38 -0800, Greg Kroah-Hartman wrote:
> 
> Good point, I don't know.
> 
> Who ever wrote this code should know this, can someone please provide a
> use-case for how this is all supposed to work?

That would be Wilson. He's wanting to use this to send updates to the
firmware on the Intel Quark, I think.
