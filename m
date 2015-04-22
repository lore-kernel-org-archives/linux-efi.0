From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi firmware
Date: Wed, 22 Apr 2015 10:45:17 -0700
Message-ID: <CALCETrXvzUnJ=CjWpGU71WKLfMR+b0txFay63Z5mtjd8zoLDHw@mail.gmail.com>
References: <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com> <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com> <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com> <20150417143640.GB3671@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
 <20150420144323.GA7261@kroah.com> <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
 <20150421075620.GA11000@kroah.com> <1429665679.2207.44.camel@HansenPartnership.com>
 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
 <1429669228.2207.46.camel@HansenPartnership.com> <CALCETrVsmQxoJ6WxVnW03Q9Hq8oH=zuv662S6TJxFwb26d=erQ@mail.gmail.com>
 <1429678269.18798.9.camel@HansenPartnership.com> <CALCETrU5u5nUJB4i0KRPZGvXgohW5ojxxOOv-_pR2OLmypvXyw@mail.gmail.com>
 <1429724049.2195.44.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429724049.2195.44.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 22, 2015 at 10:34 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Wed, 2015-04-22 at 09:50 -0700, Andy Lutomirski wrote:
>> On Apr 21, 2015 9:51 PM, "James Bottomley"
>> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> >
>> > On Tue, 2015-04-21 at 20:24 -0700, Andy Lutomirski wrote:
>> > > On Tue, Apr 21, 2015 at 7:20 PM, James Bottomley
>> > > <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> > > > On Tue, 2015-04-21 at 18:58 -0700, Andy Lutomirski wrote:
>> > > >> On Tue, Apr 21, 2015 at 6:21 PM, James Bottomley
>> > > >> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> > > >> > Andy, just on the misc device idea, what about triggering the capsule
>> > > >> > update from close()?  In theory close returns an error code (not sure if
>> > > >> > most tools actually check this, though).  That means we can do the write
>> > > >> > in chunks but pass it in atomically on the close and cat will work
>> > > >> > (provided it checks the return code of close).
>> > > >>
>> > > >> I thought about this but IIRC cat doesn't check the return value from close.
>> > > >
>> > > > It does in my copy (coreutils-8.23) :
>> > > >
>> > > >       if (!STREQ (infile, "-") && close (input_desc) < 0)
>> > > >         {
>> > > >           error (0, errno, "%s", infile);
>> > > >           ok = false;
>> > > >         }
>> > > > [...]
>> > > >   if (have_read_stdin && close (STDIN_FILENO) < 0)
>> > > >     error (EXIT_FAILURE, errno, _("closing standard input"));
>> > > >
>> > >
>> > > True, but it's stdout that we care about, not stdin :(
>> >
>> > Gosh you're determined to force me to wade through this source code,
>> > aren't you?  That's handled in lib/closeout.c:
>> >
>> > /* Close standard output.  On error, issue a diagnostic and _exit
>> >    with status 'exit_failure'.
>> >
>> > ...
>> >
>> >
>> > The point is that, admittedly much to my surprise, it all looks to be
>> > handled by cat ... so we could proceed to have the transaction completed
>> > in close in a misc device (or a sysfs file).
>> >
>> > Unless there are any other rabbits you'd like to pull out of the hat?
>>
>> No, maybe it's okay, unless there's an issue where the error would
>> only be returned on the close of the last reference of the struct
>> file.  After all, 'cat foo >/sys/bar' doesn't fully close /sys/bar
>> until after cat exits.
>
> No, cat handles that too.  It has an atexit() handler for closing
> stdout.

Indeed.  Strace tells me that:

$ cat foo >bar

opens bar and then execs cat, so cat has the only reference to bar.

So no more rabbits from me :)

--Andy
