From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 7 Nov 2012 14:55:19 +0000
Message-ID: <20121107145518.GB30662@srcf.ucam.org>
References: <87fw4nv1vj.fsf@xmission.com>
 <20121106035352.GA24698@srcf.ucam.org>
 <87hap3s3yl.fsf@xmission.com>
 <878vafqi5q.fsf@mid.deneb.enyo.de>
 <50992946.4060101@genband.com>
 <87625iwgao.fsf@mid.deneb.enyo.de>
 <7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
 <20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
 <a35e035b-de9d-4253-9e7d-ae1f1c2e2f88@email.android.com>
 <CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olivier Galibert <galibert-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 07, 2012 at 09:19:35AM +0100, Olivier Galibert wrote:
> On Tue, Nov 6, 2012 at 11:47 PM, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>wrote:
> 
> > Sure, and scripts run as root can wipe your files too. That's really not
> > what this is all about.
> 
> What it is about then? What is secure boot supposed to do for the owner of
> the computer in a linux context?  I've not been able to understand it
> through this discussion.

It provides a chain of trust that allows you to ensure that a platform 
boots a trusted kernel. That's a pre-requisite for implementing any kind 
of fully trusted platform, but it's not sufficient in itself. One of 
those additional requirements is ensuring that the kernel *stays* 
trusted - in the past an attacker could just replace the kernel on disk 
and so there was little incentive to engage in more subtle attacks, but 
now that's impossible we need to care about them.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
