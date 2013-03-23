From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Sat, 23 Mar 2013 22:50:24 +0000
Message-ID: <514E31B0.4030305@intel.com>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>  <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>  <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com> <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364070731.2553.47.camel-tCUS0Eywp2Pehftex57rkxo58HMYffqeLoYNBG0abjxeoWH0uzbU5w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Let's try this again without using HTML)

On 23/03/13 20:32, Matthew Garrett wrote:
> On Sat, 2013-03-23 at 20:24 +0000, Fleming, Matt wrote:
> 
>> Looks like we're going to have to go down the road of blacklisting
>> known bad machines after all. I was reluctant to push for that
>> originally as the result of missing a machine from the blacklist might
>> result in said machine becoming bricked, but we've now got patches in
>> place to turn off the pstore efivars code, and I suspect that most
>> distros indeed do that.
> 
> Handwaving idea - leave the size restriction in place for pstore. Remove
> it for normal setvariable calls. Downside of this is that pstore will be
> broken on machines that only clear space when the variable store is
> mostly full, but it should avoid cases where we automatically kill
> machines without also having to disable a useful feature.

Right, but it will still be possible to brick machines via the code path
that doesnt check the remaining storage space. Its less likely sure, but
its still entirely possible.

The most robust solution may be to combine the two approaches - remove the
size checks from everything but the pstore paths but enforce them across
the board for known problem machines?
