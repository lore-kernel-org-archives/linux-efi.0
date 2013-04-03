From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and actually
 used space
Date: Wed, 03 Apr 2013 14:11:34 +0100
Message-ID: <515C2A86.6070606@console-pimps.org>
References: <515150EC.7040203@redhat.com> <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com> <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364829240-26475-2-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/04/13 16:14, Matthew Garrett wrote:
> @@ -452,8 +462,33 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
>  	if (status != EFI_SUCCESS)
>  		return status;
>  
> -	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	list_for_each_entry(entry, &efivars->list, list) {
> +		var = &entry->var;
> +		status = get_var_data_locked(efivars, var);
> +
> +		if (status || !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
> +			continue;
> +
> +		active_size += var->DataSize;
> +		active_size += utf16_strsize(var->VariableName, 1024);
> +		/*
> +		 * There's some additional metadata associated with each
> +		 * variable. Intel's reference implementation is 60 bytes -
> +		 * bump that to 128 to account for vendor additions and
> +		 * potential alignment constraints
> +		 */
> +		active_size += 128;
> +	}

This is the kind of thing I was referring to when I said, 

  Hmm... I'm not convinced this will provide a long-term solution. Is there
  anything that mandates that the size of all variables has to correlate
  sensibly with the results from QueryVariableInfo()? Even if there is in
  theory, I doubt it'll be true everywhere in practice, and trying to
  workaround implementation bugs in our workarounds for other bugs is the
  path to madness.

  We can't continue this approach where we attempt to guess how the firmware
  implements variable storage, because as we've seen, there are various
  schemes out there. 

This looks like something that will differ between implementations, and the
fact that it's appearing in our code is a sure sign that this isn't the way to
go.

-- 
Matt Fleming, Intel Open Source Technology Center
