// Supabase Edge Function to send invoice emails
// Deploy: supabase functions deploy send-invoice-email

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { 
      headers: corsHeaders,
      status: 200
    })
  }

  try {
    const { to, customerName, invoiceHtml, invoiceNumber, total } = await req.json()

    if (!RESEND_API_KEY) {
      return new Response(
        JSON.stringify({ success: false, error: 'RESEND_API_KEY not configured' }),
        { 
          headers: { 
            'Content-Type': 'application/json',
            ...corsHeaders,
          }, 
          status: 500 
        }
      )
    }

    console.log('Sending email to:', to)

    // Using Resend API (free tier: 100 emails/day)
    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: 'onboarding@resend.dev', // Use this for testing (or update with your domain)
        to: [to],
        subject: `Invoice ${invoiceNumber} - Thank You for Your Purchase!`,
        html: invoiceHtml,
      }),
    })

    const data = await res.json()
    console.log('Resend response:', data)

    if (res.ok) {
      return new Response(
        JSON.stringify({ success: true, message: 'Email sent successfully', data }),
        { 
          headers: { 
            'Content-Type': 'application/json',
            ...corsHeaders,
          }, 
          status: 200 
        }
      )
    } else {
      console.error('Resend error:', data)
      return new Response(
        JSON.stringify({ success: false, error: data.message || 'Failed to send email' }),
        { 
          headers: { 
            'Content-Type': 'application/json',
            ...corsHeaders,
          }, 
          status: 400 
        }
      )
    }
  } catch (error: any) {
    console.error('Email error:', error)
    return new Response(
      JSON.stringify({ success: false, error: error.message || String(error) }),
      { 
        headers: { 
          'Content-Type': 'application/json',
          ...corsHeaders,
        }, 
        status: 500 
      }
    )
  }
})