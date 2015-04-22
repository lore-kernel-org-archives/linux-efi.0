From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 22 Apr 2015 09:27:34 -0400
Message-ID: <20150422132734.GB12062@redhat.com>
References: <20150415131906.GC21491@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com>
 <20150417143640.GB3671@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
 <20150420144323.GA7261@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
 <20150421075620.GA11000@kroah.com>
 <1429665679.2207.44.camel@HansenPartnership.com>
 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 21, 2015 at 06:58:58PM -0700, Andy Lutomirski wrote:
> On Tue, Apr 21, 2015 at 6:21 PM, James Bottomley
> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > Andy, just on the misc device idea, what about triggering the capsule
> > update from close()?  In theory close returns an error code (not sure if
> > most tools actually check this, though).  That means we can do the write
> > in chunks but pass it in atomically on the close and cat will work
> > (provided it checks the return code of close).
> 
> I thought about this but IIRC cat doesn't check the return value from close.

I checked this for the use case we'd talked about before - gnu cat
/does/ check the error code, but it's easy to miss how, because
coreutils code has some good ole' gnu-code complexity.  It'll print the
strerror() representation, but it always exits with 1 as the error
code.

Specifically the close on the output is handled by this:
---------------
  initialize_main (&argc, &argv);
  set_program_name (argv[0]);
  setlocale (LC_ALL, "");
  bindtextdomain (PACKAGE, LOCALEDIR);
  textdomain (PACKAGE);

  /* Arrange to close stdout if we exit via the
     case_GETOPT_HELP_CHAR or case_GETOPT_VERSION_CHAR code.
     Normally STDOUT_FILENO is used rather than stdout, so
     close_stdout does nothing.  */
  atexit (close_stdout);

  /* Parse command line options.  */

  while ((c = getopt_long (argc, argv, "benstuvAET", long_options, NULL))
---------------

Which in turn does:
---------------
void
close_stdout (void)
{
  if (close_stream (stdout) != 0
      && !(ignore_EPIPE && errno == EPIPE))
    {
      char const *write_error = _("write error");
      if (file_name)
        error (0, errno, "%s: %s", quotearg_colon (file_name),
               write_error);
      else
        error (0, errno, "%s", write_error);

      _exit (exit_failure);
    }

   if (close_stream (stderr) != 0)
     _exit (exit_failure);
}
---------------

exit_failure is a global from libcoreutils.a which cat never changes
from the default, so it's always 1.

(And of course error() is coreutils' own implementation rather than
glibc's because hey maybe you're not using glibc, but still, it's
there.)

So it's /annoying/ to propagate the error from there programatically,
but it can work.

-- 
        Peter
