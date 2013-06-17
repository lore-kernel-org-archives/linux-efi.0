From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Mon, 17 Jun 2013 12:02:05 +0100
Message-ID: <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130617101745.GB8569-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Joey Lee <JLee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 17.06.13 at 12:17, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 17 Jun, at 10:46:28AM, Jan Beulich wrote:
>> I agree that there ought to be an upper limit. But a single retry here
>> again looks like a tailored solution to a particular observed (mis-)
>> behavior, rather than something resulting from general considerations.
> 
> What value would you suggest for the retry?

I'd be considering something like 5...10, but this to some degree
depends on what odd kinds of behavior this in fact needs to
cover.

Jan
